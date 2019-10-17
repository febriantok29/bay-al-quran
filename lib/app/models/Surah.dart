import 'package:bay_al_quran/app/ui-builders/ArabicFormatter.dart';

enum SurahType { Makkah, Madinah }

class Surah {
  int id;
  int numberOfVerses;

  String name;
  String asma;
  String meaning;
  String description;

  SurahType type;

  String get heroTag => 'SurahHero-$id';

  Surah.fromResponse(Map<String, dynamic> response) {
    id = int.parse(response['nomor']);
    name = response['nama'];
    asma = ArabicFormatter.format(response['asma']);
    numberOfVerses = int.parse(response['ayat']);

    switch ((response['type'] as String).toLowerCase()) {
      case 'mekah':
        type = SurahType.Makkah;
        break;
      case 'madinah':
        type = SurahType.Madinah;
        break;
    }

    meaning = response['arti'];
    description = response['keterangan'];
  }
}
