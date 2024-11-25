import 'package:flutter/material.dart';
import 'package:quiz/utils/styles.dart';

class Leaderboards extends StatelessWidget {
  const Leaderboards({super.key, required this.userData});
  final Map userData;

  @override
  Widget build(BuildContext context) {
    List leaderboards = userData['leaderBoards'];
    leaderboards.sort(
      (b, a) {
        final ascore = int.parse(a.entries.first.value.split('/')[0].trim());
        final aTscore = int.parse(a.entries.first.value.split('/')[1].trim());
        final ac = ascore / aTscore;
        final bscore = int.parse(b.entries.first.value.split('/')[0].trim());
        final bTscore = int.parse(b.entries.first.value.split('/')[1].trim());
        final bc = bscore / bTscore;
        return ac.compareTo(bc);
      },
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Leader Boards'),
          centerTitle: true,
        ),
        body: ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: leaderboards.length,
            itemBuilder: (context, index) {
              final data = leaderboards[index].entries.first as MapEntry;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 250, 236, 198),
                    border: Border.all(color: Colors.black)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data.key.toString().capitalize(),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: primaryColor),
                    ),
                    Text(
                      data.value.toString(),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: primaryColor),
                    )
                  ],
                ),
              );
            }));
  }
}
