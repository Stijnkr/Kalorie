# Kalorie food catalog pipeline

Python ETL for NEVO + Open Food Facts → snapshot JSON / Supabase.

```bash
python3 -m pip install -r tool/food_db/requirements.txt
cd /path/to/Kalorie
```

## NEVO (gouden set)

Official NEVO-online dump (pipe `|` or `;` CSV):

```bash
python3 tool/food_db/cli.py nevo-import NEVO2025_v9.0/NEVO2025_v9.0.csv
```

Writes `assets/food/nevo_snapshot.min.json` (2328 producten, alle gemapte
nutriënten). Elke build krijgt een `revision`-hash; de app herimporteert zodra
die verandert, ook binnen dezelfde NEVO-release.

De bron-CSV zit niet in de repo (RIVM-licentie).

## Overlay

Alles in `tool/food_db/data/`, alles op **echte NEVO-codes**:

| bestand | doet |
|---|---|
| `portion_rules.csv` | standaardportie per voedingsmiddelgroep + naampatroon; eerste match wint, lege pattern = fallback voor de groep |
| `portions.csv` | exacte portie per NEVO-code; gaat over de regels heen |
| `aliases.csv` | extra zoekwoorden per NEVO-code |

NEVO levert zelf geen porties (de kolom `Hoeveelheid` is overal "per 100g"), dus
de regels zijn de enige bron. Dekking moet 100% blijven — elke groep hoort een
fallback te hebben, en `test_portions.py` bewaakt dat.

Zoekwoorden: NEVO's eigen `Synoniem`-kolom komt automatisch mee, en de importer
draait het streepje-achtervoegsel om (`Melk karne-` → `karnemelk`). `aliases.csv`
is voor spreektaal die in geen van beide zit (`spiegelei`, `patat`, `biertje`).

## Open Food Facts (selectief)

JSONL dump, Netherlands only, quality ≥ 55:

```bash
python3 tool/food_db/cli.py off-import path/to/off.jsonl --out tool/food_db/data/off_filtered.json
```

## Publish

Schema staat in `supabase/migrations/`. Credentials in `tool/food_db/.env`
(gitignored), of als omgevingsvariabelen:

```bash
python3 tool/food_db/cli.py publish
```

Idempotent en convergerend: producten upserten op `id`, en porties en aliassen
worden per product eerst verwijderd en dan opnieuw geschreven — de overlay is
leidend, handmatige rijen in de database overleven een run dus niet. Een
afgebroken run mag je gewoon opnieuw starten.

Na afloop hoogt hij `catalog_meta.version` op en schrijft die versie terug in de
snapshot, zodat de app niet denkt dat hij achterloopt en de hele catalogus
opnieuw ophaalt.

## Tests

```bash
cd tool/food_db && python3 -m pytest tests -q
```
