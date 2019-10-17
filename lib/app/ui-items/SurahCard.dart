import 'package:bay_al_quran/app/models/Surah.dart';
import 'package:bay_al_quran/app/navigations/SlideRightRoute.dart';
import 'package:bay_al_quran/app/pages/SurahDetails.dart';
import 'package:bay_al_quran/app/resources/BayColors.dart';
import 'package:bay_al_quran/app/resources/BayShadow.dart';
import 'package:flutter/widgets.dart';

class SurahCard extends StatelessWidget {
  final Surah surah;

  SurahCard({Key key, this.surah}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          SlideRightRoute(
            builder: (context) => SurahDetails(surah: surah),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: BayColors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: .5),
          boxShadow: BayShadow.boxShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${surah.name} (${surah.id}): 1-${surah.numberOfVerses}'),
            Padding(padding: const EdgeInsets.only(bottom: 8.0)),
            Text(
              surah.asma,
              style: TextStyle(
                fontSize: 22.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
