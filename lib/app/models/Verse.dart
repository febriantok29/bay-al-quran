import 'package:bay_al_quran/app/ui-builders/ArabicFormatter.dart';

class VerseData {
  List<VerseText> verses;

  VerseData.fromResponse(Map<String, dynamic> response) {
    final _languageList = [];

    if (response.containsKey('bahasa')) {
      final Map _language = response['bahasa'];
      if (_language.containsKey('proses')) {
        _languageList.addAll(_language['proses']);
      }
    }

    verses = [];
    if (response.containsKey('ayat')) {
      final Map _verseData = response['ayat'];

      final List _processData = [];
      if (_verseData.containsKey('proses'))
        _processData.addAll(_verseData['proses']);

      if (_verseData.containsKey('data')) {
        final Map _data = _verseData['data'];

        final _versesMap = <String, List<VerseItem>>{};
        for (final key in _data.keys) {
          if (_versesMap[key] == null) _versesMap[key] = [];

          for (var i = 0; i < _processData.length; i++)
            _versesMap[key].add(VerseItem.fromResponse(_data[key][i]));
        }

        for (var i = 0; i < _versesMap['ar'].length; i++)
          verses.add(VerseText(
            verse: _versesMap['ar'][i].verse,
            arabic: _versesMap['ar'][i].text,
            transliteration: _versesMap['idt'][i].text,
            text: _versesMap['id'][i].text,
          ));
      }
    }
  }
}

class VerseItem {
  String id;
  int verse;
  String text;

  VerseItem.fromResponse(Map<String, dynamic> response) {
    id = response['id'];
    verse = int.parse(response['ayat']);
    text = ArabicFormatter.format(response['teks']);
  }
}

class VerseText {
  int verse;
  String arabic;
  String transliteration;
  String text;

  VerseText({
    this.verse,
    this.arabic,
    this.transliteration,
    this.text,
  });
}
