import 'package:bay_al_quran/app/models/Surah.dart';
import 'package:bay_al_quran/app/routing/RouteBuilder.dart';

class SurahService {
  Future<List<Surah>> getAll() {
    return Router('surah.getAll').get().then((response) {
      final surahData = response['hasil'];
      List<Surah> surah = [];
      for (final data in surahData) {
        surah.add(Surah.fromResponse(data));
      }
      return surah;
    });
  }

  Future<Surah> getBySurahNumber(int id) {
    return Router('surah.getByNumber')
        .withParam('id', '$id')
        .get()
        .then((response) {
      final result = response['hasil'];
      return Surah.fromResponse(result[0]);
    });
  }
}
