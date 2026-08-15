import '../../core/constants.dart';

/// Vaste juridische teksten. Houd ze gelijk aan `legal/*.html` als je die
/// ergens online zet voor App Store Connect.
class LegalSection {
  const LegalSection(this.title, this.body);

  final String title;
  final String body;
}

abstract final class LegalCopy {
  static const privacy = <LegalSection>[
    LegalSection(
      'Wie',
      'Kalorie wordt aangeboden door Stijn Kroot. Vragen of verzoeken over je gegevens: ${AppInfo.supportEmail}.',
    ),
    LegalSection(
      'Wat we bewaren',
      'Om de app te gebruiken maak je een account met e-mailadres en wachtwoord. Optioneel geef je een naam. Op je toestel staat je logboek (maaltijden, water), doelen, gewicht, eigen producten, recepten en herinneringen. Als je bent ingelogd synchroniseren we die gegevens met onze server (Supabase) zodat ze terugkomen op een ander toestel.',
    ),
    LegalSection(
      'Waar het staat',
      'Op je iPhone in een lokale database, achter de versleuteling van het toestel. Verkeer naar de server gaat over HTTPS. Op de server alleen als je een account hebt, achter je eigen login. We verkopen je gegevens niet, doen niet aan tracking en tonen geen reclame.',
    ),
    LegalSection(
      'Beveiliging',
      'Je kunt Kalorie vergrendelen met Face ID of de toegangscode van je iPhone. In de appwisselaar is het logboek niet leesbaar. Een back-up van de telefoon neemt het lokale logboek niet mee; wat je nodig hebt staat in je account. Kwetsbaarheid of een datalek: ${AppInfo.supportEmail}.',
    ),
    LegalSection(
      'Wat de telefoon mag',
      'De camera is alleen voor barcodes, en alleen als je zelf scant. Meldingen sturen we alleen als je herinneringen aanzet. Face ID alleen om de app te ontgrendelen. Geen achtergrondlocatie, geen contacten, geen gezondheidsapp van Apple.',
    ),
    LegalSection(
      'Synchronisatie',
      'In je account kun je uitzetten of het logboek of het gewicht mee naar de cloud gaat. Uitloggen laat de kopie op dit toestel staan. Account verwijderen wist je account en de serverkopie. Een export die je zelf hebt bewaard blijft van jou.',
    ),
    LegalSection(
      'Bewaartermijn',
      'Zolang je account bestaat. Daarna is de serverkopie weg. Een restant kan kort in back-ups staan tot die verlopen.',
    ),
    LegalSection(
      'Jouw rechten',
      'Je kunt je gegevens exporteren via Instellingen. Je kunt je account verwijderen via Account. Voor inzage of een andere vraag mail je ${AppInfo.supportEmail}.',
    ),
    LegalSection(
      'Bronnen',
      'Voedingswaarden van onbewerkte producten komen uit NEVO-online versie 2025/9.0, RIVM, Bilthoven. Merkproducten komen van Open Food Facts (ODbL). Aanpassingen die jij zelf maakt zijn van jou, niet van NEVO.',
    ),
  ];

  static const terms = <LegalSection>[
    LegalSection(
      'De app',
      'Kalorie is een persoonlijke calorie- en gewichtslog. Een account is verplicht. Je bent zelf verantwoordelijk voor wat je invoert en hoe je de cijfers gebruikt.',
    ),
    LegalSection(
      'Geen medisch advies',
      'Kalorie is geen medisch hulpmiddel en geen dieetbehandeling. De doelen zijn een rekenhulp, geen voorschrift. Raadpleeg een arts of diëtist bij vragen over voeding, gewicht of gezondheid.',
    ),
    LegalSection(
      'Voedingswaarden',
      'Cijfers komen uit NEVO, Open Food Facts of wat je zelf invoert. Die bronnen kunnen onvolledig of verouderd zijn. NEVO-gegevens gebruiken we ongewijzigd. Je mag ze in de app niet als NEVO presenteren als je ze zelf hebt aangepast.',
    ),
    LegalSection(
      'Kosten',
      'Kalorie is gratis. We rekenen je niets voor het gebruik van NEVO, dat staat de licentie niet toe.',
    ),
    LegalSection(
      'Je account',
      'Je houdt je inlog voor jezelf. Misbruik, scrapen van de database of het doorverkopen van NEVO-gegevens is niet toegestaan. We mogen een account sluiten als dat nodig is om de dienst of anderen te beschermen.',
    ),
    LegalSection(
      'Beschikbaarheid',
      'De app en de synchronisatie kunnen uitvallen of veranderen. Een export via Instellingen is de manier om je logboek te bewaren.',
    ),
    LegalSection(
      'Contact',
      '${AppInfo.supportEmail}. Op deze voorwaarden is Nederlands recht van toepassing.',
    ),
  ];
}
