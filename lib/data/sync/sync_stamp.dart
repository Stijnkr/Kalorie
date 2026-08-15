import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Elke rij die naar de server kan, draagt een client-id die het toestel zelf
/// genereert. Daarmee blijft een regel herkenbaar ook als hij offline ontstond.
String newClientId() => _uuid.v4();
