class Routes {
  const Routes._();

  static Routes _instance;

  factory Routes() {
    if (_instance == null) _instance = const Routes._();
    return _instance;
  }

  static const Map<String, String> _routes = {
    'surah.getAll': 'quran/format/:formatType/surat',
    'surah.getByNumber': 'quran/format/:formatType/surat/:id',
    'surah.getVerse': 'quran/format/:formatType/surat/:id/ayat/:verse',
  };

  static String getUrl(String name) =>
      _routes.containsKey(name) ? _routes[name] : null;
}
