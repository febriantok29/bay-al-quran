import 'package:bay_al_quran/app/models/Verse.dart';
import 'package:bay_al_quran/app/routing/RouteBuilder.dart';

class VerseService {
  Future<VerseData> getVerse({int id, start = 0, end}) {
    var verse = start + 1;
    if (end != null && end > start) verse = '$verse-$end';

    final _params = <String, String>{
      'id': '$id',
      'verse': '$verse',
    };

    return Router('surah.getVerse').withParams(_params).get().then((response) {
      return VerseData.fromResponse(response);
    });
  }
}
