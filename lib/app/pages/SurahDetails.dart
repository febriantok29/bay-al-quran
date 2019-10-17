import 'dart:async';

import 'package:bay_al_quran/app/models/Surah.dart';
import 'package:bay_al_quran/app/models/Verse.dart';
import 'package:bay_al_quran/app/resources/BayColors.dart';
import 'package:bay_al_quran/app/services/VerseService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html2md/html2md.dart' as html2md;

class SurahDetails extends StatefulWidget {
  final Surah surah;

  SurahDetails({
    Key key,
    @required this.surah,
  }) : super(key: key);

  @override
  _SurahDetailsState createState() => _SurahDetailsState();
}

class _SurahDetailsState extends State<SurahDetails>
    with AutomaticKeepAliveClientMixin {
  final _data = <VerseData>[null];
  int _currentVerse = 0, _endVerse = 10;

  final _service = VerseService();
  final _scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  final StreamController<List<VerseData>> _verses =
      StreamController<List<VerseData>>();
  Stream<List<VerseData>> get __versesStream => _verses.stream;
  StreamSink<List<VerseData>> get __versesSink => _verses.sink;

  final StreamController<bool> _loadingData =
      StreamController<bool>.broadcast();
  Stream<bool> get __loadingDataStream => _loadingData.stream;
  StreamSink<bool> get __loadingDataSink => _loadingData.sink;

  @override
  void initState() {
    _loadData();
    _handleScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.surah.name)),
      body: _buildContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToTop,
        child: Icon(Icons.arrow_upward),
      ),
    );
  }

  Widget _buildContent() {
    final loadingIndicator = StreamBuilder<bool>(
      stream: __loadingDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('${snapshot.error}');

        if (snapshot.hasData) {
          final data = snapshot.data;
          if (data)
            return Center(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: CircularProgressIndicator(),
            ));
        }

        return Container();
      },
    );

    return StreamBuilder<List<VerseData>>(
        stream: __versesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('${snapshot.error}');

          if (snapshot.hasData) {
            final data = snapshot.data;

            return ListView.builder(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
              controller: _scrollController,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final item = data[index];

                if (item == null) return _buildSurahHeader();

                return Column(
                  children: <Widget>[
                    ...item.verses
                        .map((verse) => _buildSurahText(verse))
                        .toList(),
                    loadingIndicator,
                  ],
                );
              },
            );
          }

          return Center(child: CircularProgressIndicator());
        });
  }

  Widget _buildSurahHeader() {
    return Column(
      children: <Widget>[
        Text(
          widget.surah.asma,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 32.0,
            color: BayColors.blue,
          ),
        ),
        Text(
          widget.surah.meaning,
          style: TextStyle(fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
        Padding(padding: const EdgeInsets.only(bottom: 20.0)),
        _buildMarkdown(widget.surah.description),
        Padding(padding: const EdgeInsets.only(bottom: 30.0)),
      ],
    );
  }

  Widget _buildSurahText(VerseText verse) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          SelectableText.rich(
            TextSpan(
              text: verse.arabic,
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.w600,
              ),
              children: <InlineSpan>[
                TextSpan(
                  text: ' (${verse.verse})',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            textAlign: TextAlign.end,
          ),
          _buildMarkdown('${verse.transliteration} (${verse.verse})'),
          Padding(padding: const EdgeInsets.only(bottom: 10.0)),
          _buildMarkdown('(${verse.verse}) ${verse.text}'),
        ],
      ),
    );
  }

  static Widget _buildMarkdown(String input) =>
      MarkdownBody(data: html2md.convert(input));

  void _handleScrollController() {
    _scrollController.addListener(() {
      final endList = _scrollController.offset ==
          _scrollController.position.maxScrollExtent;
      if (endList && _endVerse != widget.surah.numberOfVerses) _loadData();
    });
  }

  Future<void> _loadData() async {
    __loadingDataSink.add(true);
    final result = await _service.getVerse(
      id: widget.surah.id,
      start: _currentVerse,
      end: _endVerse,
    );

    _data.add(result);
    __versesSink.add(_data);

    _currentVerse = _endVerse;
    if (_endVerse + 10 < widget.surah.numberOfVerses)
      _endVerse = _endVerse + 10;
    else
      _endVerse = widget.surah.numberOfVerses;
    __loadingDataSink.add(false);
  }

  void _scrollToTop() =>
      _scrollController.animateTo(_scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);

  @override
  void dispose() {
    _verses.close();
    _loadingData.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
