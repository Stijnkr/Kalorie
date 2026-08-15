# Food Database Architecture — Kalorie

Datum: 2026-08-15
Status: stap 1 en 2 af. Volledige NEVO 2025/9.0 (2328 producten) met porties en
aliassen staat zowel in de app-snapshot als in Supabase (catalogusversie 4).
Zoek-RPC en ranking zijn gelijkgetrokken met de app. Volgende: stap 3, de
selectieve OFF branded laag, plus een popularity-seed — nu scoort elk
NEVO-product identiek en beslist de naamlengte de volgorde.

## Context (wat er nu is)

Kalorie is offline-first, privacy-first, zonder accounts. Voedsel zit in Isar.

- `Food` slaat alleen kcal / eiwit / koolhydraten / vet + 1 portie op.
- NEVO komt uit `assets/nevo/nevo_2025_9_0.min.json`: **99 producten**, geen micronutriënten. Importer: `lib/data/nevo/nevo_importer.dart`. Converter: `tool/nevo_convert.dart` (alleen 4 macro’s).
- Open Food Facts wordt **live** gezocht/gescand (`OffRemoteDataSource`) en daarna in Isar gecached. Rate limits: 10 zoek / 15 barcode per minuut.
- Zoeken is lokaal (`nameNormalizedContains`) + optioneel remote OFF. Ranking: recent → favoriet → startsWith → bron (custom > NEVO > OFF).
- Dagboek (`DiaryEntry`) kopieert naam + macro’s; geen live-koppeling naar cataloguswijzigingen.

Doel van deze architectuur: een **eigen Nederlandse catalogus in Supabase**, met NEVO als gouden standaard, OFF alleen selectief voor verpakte merken, en een Kalorie-laag voor porties/aliases/ranking. De app blijft offline-first; gebruikersdata blijft lokaal.

---

## 1. Mapstructuur

Pipeline hoort **niet** in `lib/` (wordt niet meegeleverd). Catalogus-client wel. Bestaande `lib/data/`-indeling uitbreiden, geen parallelle `lib/food_database/`.

```
Kalorie/
  supabase/
    migrations/
      001_food_catalog.sql          # tabellen, indexes, RLS
      002_search.sql                # pg_trgm, search RPC
    seed/
      nutrient_defs.sql             # NEVO/EuroFIR codes + NL labels
  tool/food_db/                     # ETL, draait lokaal / CI
    README.md
    requirements.txt                # python: pandas, rapidfuzz, supabase
    config.py
    normalize.py                    # namen, merken, barcodes, match_key
    quality.py                      # quality score + Atwater-check
    nevo_import.py                  # NEVO CSV/XLS → products
    off_import.py                   # OFF dump → gefilterde branded products
    dedupe.py                       # OFF↔OFF + candidate queue
    portions.py                     # groepsregels + exacte porties (data/portion_rules.csv, data/portions.csv)
    aliases.py                      # synoniemen (havermout/havervlokken)
    publish.py                      # upsert naar Supabase
    snapshot.py                     # gzip JSON snapshot voor de app
  lib/data/food/                    # domein (geen Isar, geen UI)
    catalog_product.dart            # immutable catalogusmodel
    nutrients.dart                  # codes, units, display groups
    match_key.dart                  # dezelfde normalisatie als pipeline
    ranking.dart                    # cloud + lokale ranking (vervangt core/food_search_rank deels)
  lib/data/remote/
    catalog_client.dart             # Supabase: search, getByBarcode, delta
    off_client.dart                 # blijft: alleen barcode-fallback
  lib/data/local/collections/
    food.dart                       # Isar: cataloguscache + user state
  lib/data/repositories/
    food_repository.dart            # lokale search/cache
    catalog_repository.dart         # sync + merge cloud→Isar
  assets/food/
    nutrient_defs.json              # klein, altijd in de app
    nevo_snapshot.min.json          # volledige NEVO (vervangt 99-item file)
```

Verantwoordelijkheden:

| Bestand | Doet | Doet niet |
|---|---|---|
| `tool/food_db/*.py` | importeren, scoren, dedupen, publiceren | Flutter UI |
| `lib/data/food/*` | gedeelde types + ranking | netwerk, Isar writes |
| `catalog_client.dart` | REST/RPC naar Supabase | business ranking |
| `catalog_repository.dart` | snapshot/delta sync, merge-regels | dagboek |
| `food_repository.dart` | lokale query, recents, favorites, overrides | OFF API |
| `off_client.dart` | barcode miss in catalogus | zoeken (dat gaat via eigen DB) |

Bestaande `lib/data/nevo/` wordt na de NEVO-snapshot-migratie verwijderd of tot een dunne loader gereduceerd.

---

## 2. Supabase schema

### 2.1 Nut tenten-opslag: hybride (kolommen + jsonb)

Geen EAV-tabel (`product_id, nutrient_code, value`) in v1. Dat is ~2.200 NEVO × ~130 codes plus tienduizenden OFF-rijen: zwaar om te synchen, traag in de app, weinig winst.

**Keuze:**

- **Kolommen** voor het hot path (UI, ranking, plausibiliteit, snapshot).
- **`nutrients jsonb`** voor de rest, keyed op stabiele NEVO-codes (`VITC`, `CA`, `NIA`, …).
- **`nutrient_defs`** voor labels, eenheden, volgorde.

GIN op jsonb later alleen als we “hoog in ijzer”-filters nodig hebben.

### 2.2 Tabellen

#### `nutrient_defs`

| Kolom | Type | Notes |
|---|---|---|
| code | text PK | NEVO-code, bijv. `ENERCC`, `FIBT`, `VITC` |
| name_nl | text | |
| unit | text | `kcal`, `g`, `mg`, `µg` |
| group | text | `energy`, `macro`, `carb`, `fat`, `mineral`, `vitamin`, `other` |
| decimals | smallint | |
| is_core | bool | true = ook als kolom op `products` |
| sort_order | smallint | |

Core-kolommen (altijd aanwezig): `ENERCC`, `PROT`, `CHO`, `FAT`, `FIBT`, `SUGAR`, `FASAT`, `NA`/`salt`, `ALC`.

Overige jsonb (NEVO volledig, OFF alleen als aanwezig): vitaminen A/D/E/K/C/B1/B2/B3/B6/B12/foliumzuur; mineralen Ca/Fe/Mg/K/Zn/Se/I/P; cholesterol, transvet, EPA/DHA, water.

#### `products`

Eén rij = één uniek voedingsmiddel in **onze** catalogus. NEVO-generiek en AH-melk zijn twee rijen.

| Kolom | Type | Notes |
|---|---|---|
| id | uuid PK | |
| kind | text | `generic` \| `branded` |
| source_primary | text | `nevo` \| `off` \| `kalorie` |
| nevo_code | text | uniek waar niet null |
| off_id | text | OFF `_id` / barcode-code, uniek waar niet null |
| name | text not null | display (NL) |
| brand | text | null voor generic |
| category | text | NEVO-groep of OFF category_nl |
| name_normalized | text not null | `lower(unaccent(trim))` |
| brand_normalized | text | |
| match_key | text | `brand_normalized + '|' + name_normalized`; generated/stored |
| energy_kcal_100g | numeric(8,2) not null | |
| protein_100g | numeric(8,2) not null | |
| carbs_100g | numeric(8,2) not null | |
| fat_100g | numeric(8,2) not null | |
| fiber_100g | numeric(8,2) | |
| sugars_100g | numeric(8,2) | |
| sat_fat_100g | numeric(8,2) | |
| salt_100g | numeric(8,2) | of sodium → salt = Na×2.5 |
| alcohol_100g | numeric(8,2) | |
| nutrients | jsonb not null default '{}' | overige per 100 g |
| quality_score | smallint not null default 0 | 0–100 |
| popularity | integer not null default 0 | interne teller, geen PII |
| nl_relevance | smallint not null default 0 | 0–100 |
| is_published | bool not null default false | |
| generic_product_id | uuid FK products | optioneel: branded → NEVO voor missing micros |
| data_version | integer not null default 1 | voor delta-sync |
| source_updated_at | timestamptz | |
| created_at / updated_at | timestamptz | |

Constraints:

```sql
check (kind in ('generic','branded'))
check (source_primary in ('nevo','off','kalorie'))
unique (nevo_code) where nevo_code is not null
unique (off_id) where off_id is not null
unique (match_key) where kind = 'branded' and match_key is not null
-- generic NEVO: unique op nevo_code is genoeg; namen mogen lijken
```

#### `product_barcodes`

| Kolom | Type |
|---|---|
| barcode | text PK (GTIN, alleen digits) |
| product_id | uuid FK not null |
| is_primary | bool |

Eén barcode → één product. Extra EAN’s van hetzelfde SKU mogen extra rijen zijn naar hetzelfde `product_id`.

#### `product_aliases`

| Kolom | Type |
|---|---|
| id | uuid PK |
| product_id | uuid FK |
| alias | text |
| alias_normalized | text |
| source | text (`kalorie` \| `nevo` \| `off`) |

Uniek: `(product_id, alias_normalized)`.

#### `product_portions`

| Kolom | Type |
|---|---|
| id | uuid PK |
| product_id | uuid FK |
| label | text | `1 snee`, `1 opscheplepel` |
| grams | numeric(8,2) |
| is_default | bool |
| source | text |

Uniek: `(product_id, label)` waar `is_default` hoogstens één true per product (partial unique index).

#### `product_sources` (audit, klein)

Herkomst per product, zodat we NEVO kunnen herimporteren zonder Kalorie-overrides te wissen.

| Kolom | Type |
|---|---|
| product_id | uuid PK/FK |
| nevo_version | text |
| off_last_modified | timestamptz |
| raw_hash | text | skip als ongewijzigd |

#### `duplicate_candidates`

Handmatige review-queue. Geen auto-merge op fuzzy.

| Kolom | Type |
|---|---|
| id | uuid |
| product_a / product_b | uuid |
| reason | text | `same_barcode`, `name_brand`, `fuzzy` |
| similarity | numeric |
| status | text | `open` \| `merged` \| `kept_separate` |

#### `catalog_meta`

Eén rij: `version` (int, monotonic), `nevo_version`, `off_dump_date`, `published_at`, `product_count`.

#### `import_runs`

Pipeline-log: bron, started/finished, rows_in, inserted, updated, skipped, rejected, notes.

#### `product_suggestions` (later)

Anonieme/opt-in correcties. Niet in v1 nodig. Kolommen: product_id, field, old/new, status, created_at. Geen koppeling aan dagboek.

### 2.3 Indexes

```sql
create index on products (is_published) where is_published;
create index on products (kind);
create index on products (quality_score desc);
create index on products (popularity desc);
create index on products using gin (name_normalized gin_trgm_ops);
create index on products using gin (match_key gin_trgm_ops);
create index on product_aliases using gin (alias_normalized gin_trgm_ops);
create index on product_barcodes (product_id);
-- search document
alter table products add column search_text text
  generated always as (
    name_normalized || ' ' || coalesce(brand_normalized,'')
  ) stored;
create index on products using gin (search_text gin_trgm_ops);
```

Extensions: `pg_trgm`, `unaccent`.

### 2.4 Search RPC

```sql
search_products(q text, lim int default 30)
```

- `q` normaliseren (unaccent, lower).
- Match op `search_text % q` of `alias_normalized % q`.
- Score in SQL: trigram similarity + `popularity` log + `quality_score` + `nl_relevance` + boost `kind=generic` bij korte queries (“melk”, “ei”).
- Alleen `is_published`.

Barcode: directe lookup `product_barcodes`, geen fuzzy.

### 2.5 RLS

Geen user accounts nodig voor de catalogus.

- `anon`: `SELECT` op published products + barcodes + aliases + portions + nutrient_defs + catalog_meta.
- Writes: alleen `service_role` (pipeline).
- Geen RLS-policy die dagboek of profielen naar de cloud stuurt.

---

## 3. Deduplicatie

### 3.1 Twee werelden, niet forceren tot één rij

| | Generic (NEVO) | Branded (OFF / Kalorie) |
|---|---|---|
| Voorbeeld | “Melk halfvol” | “Campina Halfvolle melk” |
| Barcode | meestal geen | verplicht |
| Nutriënten | volledig, lab | etiket, vaak onvolledig |
| Merge? | **nooit** vervangen door OFF | blijft eigen rij |

“Melk” in zoekresultaten: NEVO bovenaan bij query zonder merk; branded erna, gerankt op populariteit.

### 3.2 Matching-volgorde (pipeline)

1. **Barcode (GTIN)**  
   Normaliseer (leading zeros, EAN-13). Zelfde barcode → zelfde branded product. Hoogste `quality_score` wint; andere barcodes/aliases worden samengevoegd. **Nooit** een NEVO-rij op barcode overschrijven.

2. **`match_key` = brand + naam**  
   Alleen branded. `normalize`: lower, unaccent, strip `®`, punctuation, contentsize (`500 ml`, `250g`), stopwoorden (`de`, `het`, `vers`).  
   Exacte match_key → upsert.

3. **Fuzzy OFF↔OFF** (niet auto-merge)  
   Als similarity ≥ 0.92 (rapidfuzz token_set) **en** kcal ±10% **en** zelfde merk: rij in `duplicate_candidates`. Review later of script met allowlist.

4. **NEVO ↔ OFF**  
   Geen merge. Optioneel `generic_product_id` alleen als:
   - OFF category mappable naar NEVO-groep
   - kcal ±15%
   - naam-tokens overlap (zonder merk)
   - quality_score ≥ 70  
   Gebruik: ontbrekende micros invullen in de **app-weergave**, niet de etiket-macro’s overschrijven.

### 3.3 Quality score (0–100)

Start 0, cap 100. Reject onder drempel (zie import).

| Regel | Punten |
|---|---|
| kcal + P/C/V aanwezig en ≥ 0 | +25 |
| Atwater-plausibel: `kcal ≈ 4P+4C+9F+7A` binnen 20% | +15 |
| vezel + suiker + zout/natrium | +10 |
| Nederlandse naam (`product_name_nl` of NL language) | +10 |
| land NL of BE | +10 |
| merk aanwezig en niet leeg/`unknown` | +8 |
| serving size parsebaar naar gram | +7 |
| nutriscore of nova aanwezig | +5 |
| images / complete OFF completeness ≥ 0.6 | +5 |
| naam te generiek zonder onderscheidend merk (“appel”, “rijst”) | −15 |
| kcal=0 terwijl macros > 0, of macros-som onzinnig | −30 / reject |
| no_nutrition_data, of alleen kJ zonder macros | reject |

`nl_relevance`: 100 als `countries_tags` NL; 70 BE; 40 EU-merk dat in NL-winkels zit (later allowlist AH/Jumbo/Lidl/Plus/Aldi); anders 0 en meestal niet importeren.

NEVO-producten: `quality_score = 100`, `nl_relevance = 100`, `kind = generic`.

---

## 4. Import pipeline

Python in `tool/food_db/`. Dart is onhandig voor OFF-dumps (GB’s). Herhaalbaar: elke run is idempotent via `nevo_code` / `off_id` / barcode / `raw_hash`.

### 4.1 NEVO — eenmalig, daarna per RIVM-release

Bron: NEVO-online export (CSV/XLS), versie bijv. 2025/9.0. Licentie: RIVM-voorwaarden respecteren (bronvermelding in app/settings).

Stappen:

1. Parse alle nutrient-kolommen via `nutrient_defs` mapping (niet alleen ENERCC/PROT/CHO/FAT).
2. Skip rijen zonder naam of zonder ENERCC.
3. `kind=generic`, `is_published=true`, scores 100.
4. Porties: NEVO levert er geen (`Hoeveelheid` is overal "per 100g"), dus eigen overlay: `data/portion_rules.csv` geeft elke voedingsmiddelgroep een default via naampatronen (brood → 1 snee 35 g, cracker → 1 stuk 7 g), `data/portions.csv` overschrijft per NEVO-code waar dat misgaat (droge pasta, kipfilet). Dekking is 100%.
5. Aliases: NEVO's `Synoniem`-kolom + automatische omkering van het streepje-achtervoegsel (`Melk karne-` → `karnemelk`) + handmatige spreektaal in `data/aliases.csv` (`spiegelei`, `patat`, `biertje`).
6. Upsert op `nevo_code`. Kalorie-overrides (`source_primary=kalorie` of suggestion accepted) niet overschrijven.
7. Schrijf `assets/food/nevo_snapshot.min.json` voor offline v1.
8. Log in `import_runs`.

App-bundel: **volledige NEVO** (~2.200 items) is klein genoeg (met jsonb-nutriënten waarschijnlijk 1–3 MB minified). De huidige 99-item file is een tijdelijke subset en verdwijnt.

### 4.2 Open Food Facts — periodiek, selectief

Niet de live search-API vullen als catalogus. Gebruik de **OFF dump** (JSONL) of de filtered data-export.

Filters (hard, voor insert):

- `countries_tags` bevat `en:netherlands` **of** (optioneel later) `en:belgium`
- barcode aanwezig, alleen digits, lengte 8–14
- `product_name` of `product_name_nl` niet leeg
- nutriments: energy-kcal (of kJ) + proteins + carbohydrates + fat
- `quality_score >= 55` na berekening
- niet in exclude-categories: non-food, supplements-only (besluit: vitaminenpotten skippen in v1)
- taal: voorkeur NL; EN/FR alleen als NL-naam ontbreekt maar land=NL

Import-modus:

- **Wekelijks** (of maandelijks tot de DB stabiel is): delta op `last_modified_t`.
- Upsert op barcode → `product_barcodes` + `off_id`.
- Als product bestaat en `raw_hash` gelijk: skip.
- Als product bestaat, niet `source_primary=kalorie`, en quality hoger: update macros/naam.
- Nooit NEVO-rij updaten vanuit OFF.
- `is_published = quality_score >= 55`.
- Cap v1: **niet meer dan ~15–25k branded** producten. Sorteer op quality × nl_relevance; rest niet publiceren (wel in staging-tabel als we die later willen).

Live OFF in de app blijft **alleen barcode-fallback** als de eigen DB niets heeft. Geen OFF-tekstsearch meer in de UI.

### 4.3 Kalorie-laag (handmatig + later semi-auto)

CSV’s in `tool/food_db/data/`:

- `aliases.csv` — product_id/nevo_code, alias
- `portions.csv` — extra NL-porties
- `overrides.csv` — correcties (naam, serving, nutrient)
- `popularity_seed.csv` — initiële ranking (AH-basis, NEVO-groep frequentie)

Deze files winnen van NEVO/OFF bij conflict (`source_primary` blijft nevo/off; override-velden in aparte kolommen of `product_sources` + apply-stap). Simpelste v1: overrides worden ná import toegepast en zetten `updated_at`.

### 4.4 Herhalen / updaten

```
python -m tool.food_db.nevo_import --file nevo.csv --version 2025/9.0
python -m tool.food_db.off_import --dump off.jsonl --since 2026-08-01
python -m tool.food_db.dedupe
python -m tool.food_db.publish
python -m tool.food_db.snapshot --out assets/food/
```

`catalog_meta.version` += 1 bij publish. App haalt die versie op.

---

## 5. App-integratie (Flutter + Isar)

### 5.1 Rollen

| Laag | Inhoud |
|---|---|
| Supabase | bron van waarheid voor de **gedeelde** catalogus |
| Isar `Food` | cache van catalogus + **user state** (favorite, lastUsed, lastAmount, userOverridden) |
| Isar `DiaryEntry` | onveranderd: snapshot van macros op log-moment |

Privacy: geen account, geen sync van dagboek/gewicht. Alleen read-only catalogus + optioneel later anonieme suggestions.

### 5.2 Isar-model (uitbreiding, geen breaking van dagboek)

Bestaande velden blijven. Toevoegen:

- `catalogId` (String, uuid, indexed)
- `kind` (generic/branded)
- `qualityScore`, `popularity`, `nlRelevance`
- `fiber100g`, `sugars100g`, `satFat100g`, `salt100g`
- `nutrientsJson` (String) — overige
- `dataVersion` (int)
- `userOverridden` blijft: cloud mag die rij niet overschrijven

`FoodSource`: `nevo | off | custom | catalog` — of `off` hergebruiken voor branded. Pragmatisch: `nevo` = generic, `off` = branded uit onze DB (niet meer “live OFF”), `custom` = user.

### 5.3 Offline-first strategie (drie lagen)

1. **Altijd in de binary:** nutrient_defs + volledige NEVO-snapshot. App werkt zonder netwerk, zoals nu, maar met ~2.200 goede generieke producten i.p.v. 99.
2. **Eerste Wi‑Fi / achtergrond:** branded snapshot (top N op popularity, gzip JSON of split files). Doel: 5–10k merken die in NL scannen/zoeken dekken. Opslaan in Isar.
3. **Online delta:** `catalog_meta.version` > lokaal → RPC `products_since(version)` of `updated_at`. Klein houden.
4. **Miss:** barcode of zoekquery niet lokaal → Supabase RPC. Hit cachen in Isar.
5. **Laatste vangnet:** huidige OFF barcode-API, daarna custom-formulier.

Zoeken in de app:

- Query leeg: recents / favorites (ongewijzigd).
- Query lokaal in Isar (name, brand, later aliases-tabel lokaal of aliases in `nameNormalized` concatenatie).
- Ranking lokaal: **device-recents/favorites eerst**, daarna catalogus-score.
- Geen “Zoek online” knop naar OFF; wel optioneel “meer resultaten” naar eigen Supabase als lokaal < N hits en online.

### 5.4 Ranking

**Device (altijd eerst):** `lastUsedAt` > favorite > rest.

**Catalogus-score** (cloud RPC én lokaal dezelfde formule in `lib/data/food/ranking.dart`):

```
0.40 * text_match      # 1.0 startsWith, 0.7 token, 0.4 contains
+ 0.25 * log(1+popularity) genormd
+ 0.15 * quality_score/100
+ 0.12 * nl_relevance/100
+ 0.08 * generic_boost  # +1 bij korte query zonder merkwoorden
```

Generic boost voorkomt dat 40 AH-melkvarianten “melk” overspoelen. Zoekt iemand “campina melk”, dan wint branded.

Populariteit v1: seed + hoe vaak **deze installatie** het logt blijft lokaal. Globale popularity later: opt-in anonieme teller (`increment_popularity(product_id)` RPC, geen user-id). Niet nodig om de DB te lanceren.

---

## 6. Onderhoud en kwaliteit

### 6.1 User-correcties (v1 lokaal)

Huidige `userOverridden` blijft. Edit in de app raakt alleen Isar. Cloud-catalogus ongewijzigd. Dit past bij geen-accounts.

### 6.2 Cloud-schonermaken (pipeline + klein proces)

- Wekelijkse OFF-delta; reject-log bekijken (`quality_score` net onder drempel).
- `duplicate_candidates` maandelijks: mergen of `kept_separate`.
- Overrides CSV voor structurele fouten (verkeerde NEVO-portie, OFF kcal-typo).
- NEVO-release: volledige reimport, daarna overlays opnieuw toepassen.
- Unpublished houden wat niet NL-relevant is; niet wissen (herpubliceren kan).
- Later: `product_suggestions` met moderatie. Tot die tijd: issues/CSV.

### 6.3 Wat we bewust niet doen

- Geen user-generated catalogus zonder review.
- Geen volledige wereldwijde OFF-spiegel.
- Geen micronutriënten-UI forceren in v1 van dit plan (data wél opslaan).
- Geen accounts/sync van diary.
- Geen pgvector/embeddings voor zoeken (trigram + aliases is genoeg voor NL voedsel).

---

## 7. Implementatievolgorde

Bouwbaar in slices. Elke slice is alleen shipbaar als de app niet stuk gaat.

### Stap 0 — Fundament (geen app-gedrag nodig)

1. `supabase/migrations/001_food_catalog.sql` + `nutrient_defs`.
2. `tool/food_db/normalize.py` + `quality.py` + tests met 20 voorbeeldrijen.
3. `lib/data/food/nutrients.dart` (zelfde codes als SQL).

### Stap 1 — NEVO volledig (grootste kwaliteitssprong)

4. `nevo_import.py`: alle nutriënten + porties.
5. Publish naar Supabase + `assets/food/nevo_snapshot.min.json`.
6. Isar `Food` uitbreiden; importer vervangt 99-item file.
7. UI ongewijzigd (toont nog 4 macro’s); data is klaar voor later.

**Eerste merkbare win:** betere generieke NL-database, offline, zonder OFF-rommel.

### Stap 2 — Eigen zoeken i.p.v. live OFF-search

8. `002_search.sql` + `catalog_client.dart` + `catalog_repository.dart`.
9. Add-food: lokale NEVO + Supabase search; OFF-search knop verwijderen.
10. Scanner: eigen barcode-tabel eerst, dan OFF-fallback.

### Stap 3 — Selectieve OFF branded laag

11. `off_import.py` met filters + quality drempel.
12. Dedupe barcode + match_key; candidates-tabel.
13. Snapshot van top branded voor offline.
14. Ranking-formule in app gelijk trekken met RPC.

### Stap 4 — Overlay

15. aliases.csv, extra portions, popularity seed.
16. Generic-link `generic_product_id` (optioneel, mag wachten).
17. Delta-sync op `catalog_meta.version`.

### Stap 5 — Onderhoud (pas als 1–3 stabiel zijn)

18. Wekelijkse import-job (GitHub Action of lokale cron).
19. Suggestion-tabel als we correcties willen oogsten.
20. Micronutriënten in amount/detail-UI.

---

## 8. Eerste bouwblokken (start hier)

In deze volgorde, zonder over-engineering:

1. **SQL schema + nutrient_defs** — contract waar pipeline en app van afhangen.
2. **NEVO full import** — gouden set; maakt de 99-item subset overbodig.
3. **Isar-velden + snapshot loader** — app heeft de data offline.
4. **Supabase search RPC + barcode lookup** — live OFF-search kan uit.
5. **OFF filter-import** — pas daarna merken/barcodes in volume.

Stap 1–3 leveren al een schone Nederlandse database. OFF komt erbij als laag, niet als fundament.

---

## 9. Open punten (bewust klein houden)

- NEVO-licentie/herdistributie in de app-binary: bronvermelding + check RIVM-voorwaarden voor de volledige tabel.
- BE meenemen in v1 OFF-filter of strikt NL-only (advies: NL-only eerst).
- Exacte branded-cap (15k vs 25k) na de eerste dump-run bepalen op quality-histogram.
- `supabase_flutter` dependency + anon key in de app: alleen public read.

Niet blokkerend voor stap 0–1.
