# Kalorie

Een rustige calorietracker voor iOS en Android. Nederlandse voedingsdata uit
NEVO, merkproducten via Open Food Facts, en een logboek dat offline werkt en
optioneel met je account meereist.

Op het startscherm staat één cijfer: hoeveel kcal je nog over hebt. Al het
andere staat een niveau dieper. Loggen kost één tik, want het logvel opent op je
recente producten met de portie die je vorige keer koos.

## Wat het doet

**Loggen**

* Dagkaart met "kcal over" voorop, macro's met een eigen doel eronder, en de
  volledige voedingswaarden (vezels, suikers, verzadigd vet, zout) achter
  "Alles zien".
* Logvel met je recente producten. De plus boekt direct in de maaltijd van dit
  moment, met "Ongedaan" in de toast.
* Zoeken in NEVO en Open Food Facts, barcodes scannen, en zelf producten
  aanmaken met de waarden per 100 g.
* Recepten: een vaste combinatie ingrediënten die je als één portie logt.
* Water bijhouden in glazen van 250 ml.

**Overzicht**

* Weekgrafiek met je dagdoel als streepjeslijn, en per dag het verschil met dat
  doel.
* Gewicht met verloop over de laatste metingen.
* Doelen waarbij de macro's meeschuiven als je het kcal-doel verzet.

**Praktisch**

* Herinneringen per maaltijd die overslaan wat je al gelogd hebt.
* Account met synchronisatie over je toestellen. Zonder account blijft alles
  lokaal.
* Toegangscode of biometrie voor de app.
* Export van al je gegevens als JSON.
* Nederlands en Engels, licht en donker thema.

> Screenshots volgen. Zet ze in `docs/screenshots/` en verwijs ze hier.

## Onder de motorkap

| Laag | Keuze |
| --- | --- |
| UI | Flutter, Material 3 met een eigen thema (`lib/app/theme.dart`) |
| State | Riverpod |
| Navigatie | go_router |
| Lokale opslag | Isar, de app werkt volledig zonder netwerk |
| Cloud | Supabase (auth, Postgres met RLS) |
| Scannen | mobile_scanner |
| Meldingen | flutter_local_notifications |

### Offline-first

Isar is de waarheid op het toestel. De synchronisatie
(`lib/data/sync/sync_engine.dart`) duwt eerst wat lokaal openstaat naar boven en
haalt daarna op wat sinds de vorige keer op de server veranderde. Botsingen
gaan op last-write-wins via `updated_at`. Verwijderen gebeurt met tombstones,
zodat een regel die je op je telefoon weghaalt niet terugkomt vanaf je iPad.
Elke rij draagt een `client_id` die het toestel zelf genereert, zodat iets dat
offline ontstond bij de eerste push aan de juiste serverrij gekoppeld wordt.

### Privacy

Zonder account verlaat er niets je toestel. Met een account staan je gegevens
achter row level security op `auth.uid()`, dus niemand kan bij een ander z'n
logboek. "Account verwijderen" wist de sessies, de refresh-tokens en de
gebruiker, en alles wat eraan hangt verdwijnt via `on delete cascade`.

## Aan de slag

```bash
flutter pub get
dart run build_runner build
flutter run
```

De app draait meteen tegen het bestaande Supabase-project. Wil je je eigen
backend, geef die dan mee:

```bash
flutter run --dart-define=KALORIE_SUPABASE_URL=https://jouwproject.supabase.co --dart-define=KALORIE_SUPABASE_PUBLISHABLE_KEY=sb_publishable_...
```

Zonder geldige sleutels start de app gewoon op en werkt alles lokaal. Account
en synchronisatie zijn dan uitgeschakeld.

### Codegeneratie

Isar-collecties, Riverpod-providers en freezed-modellen worden gegenereerd.
Draai `dart run build_runner build` na elke wijziging in
`lib/data/local/collections/`. Vertalingen komen uit `lib/core/l10n/*.arb` en
worden door `flutter gen-l10n` omgezet.

### Tests

```bash
flutter analyze
flutter test
```

## Database

De migraties in `supabase/migrations/` draaien in volgorde:

| Migratie | Inhoud |
| --- | --- |
| `001` t/m `006` | Productcatalogus: NEVO, merkproducten, zoekindex en ranking |
| `007` | Gebruikersgegevens: logboek, doelen, gewicht, water, eigen producten, recepten, herinneringen, alles achter RLS |
| `008` en `011` | `delete_account()`: verwijdert sessies, tokens en de gebruiker |
| `009` | Last-write-wins op de client-tijd, weekdag voor het weegmoment |
| `010` | Feedback vanuit de app |

De catalogus is publiek leesbaar, gebruikersgegevens zijn dat nooit. De
pijplijn die de catalogus vult staat in `tool/food_db/` en schrijft met de
service-role-sleutel uit je omgeving. Die staat niet in deze repo.

## Structuur

```
lib/
  app/          thema, router, opstarten
  core/         rekenwerk (porties, macro's, datums), gedeelde widgets, vertalingen
  data/
    local/      Isar-collecties
    remote/     Open Food Facts en de cataloguscliënt
    repositories/
    sync/       synchronisatie-engine
  features/     één map per scherm
supabase/       migraties en seed
tool/food_db/   Python-pijplijn voor de productcatalogus
```

## Bronnen

Voedingswaarden komen uit NEVO online versie 2025/9.0, RIVM, Bilthoven en
andere databronnen. Merkproducten komen van Open Food Facts onder de
[Open Database License](https://opendatacommons.org/licenses/odbl/). De
volledige vermelding staat in `assets/legal/nevo_attribution.txt`.
