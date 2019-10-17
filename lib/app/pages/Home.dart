import 'package:bay_al_quran/app/models/Surah.dart';
import 'package:bay_al_quran/app/services/SurahService.dart';
import 'package:bay_al_quran/app/ui-items/SurahCard.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String title;

  const Home({Key key, this.title}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _surah = SurahService().getAll();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackButton,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: _buildContent(),
      ),
    );
  }

  Future<bool> _handleBackButton() async {
    var result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              content: Text('Want to exit?'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('Yes')),
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No')),
              ],
            ));

    return result == null ? false : result;
  }

  Widget _buildContent() {
    return Center(
      child: FutureBuilder<List<Surah>>(
          future: _surah,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            if (snapshot.hasData) {
              final data = snapshot.data;
              return ListView(
                children: data
                    .map((surah) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SurahCard(surah: surah),
                        ))
                    .toList(),
              );
            }

            return CircularProgressIndicator();
          }),
    );
  }
}
