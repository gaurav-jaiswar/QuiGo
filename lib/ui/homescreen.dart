import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz/ui/profile.dart';
import 'package:quiz/ui/qleaderboard.dart';
import 'package:quiz/utils/const.dart';
import 'package:quiz/utils/styles.dart';

//<a href="https://www.flaticon.com/free-icons/quiz" title="quiz icons">Quiz icons created by Freepik - Flaticon</a>
class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _selected = 0;
  final db = FirebaseFirestore.instance;
  late Map trivia;
  late Map general;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    general = (await db.collection('quiz').doc('general').get()).data()!;
    trivia = (await db.collection('quiz').doc('trivia').get()).data()!;
    loading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          selectedIconTheme: IconThemeData().copyWith(size: 30),
          unselectedIconTheme: IconThemeData().copyWith(size: 20),
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          currentIndex: _selected,
          onTap: (value) => setState(() {
                _selected = value;
              }),
          items: [
            BottomNavigationBarItem(
                label: "Home", icon: Icon(Icons.home_max_outlined)),
            BottomNavigationBarItem(
                label: "Profile", icon: Icon(Icons.person_outlined)),
          ]),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _selected == 1
              ? ProfilePage()
              : RefreshIndicator.adaptive(
                  onRefresh: () async {
                    setState(() {
                      loading = true;
                    });
                    fetchData();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              width: double.maxFinite,
                              height: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      const Color.fromARGB(255, 107, 64, 64)),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 50),
                                Text(
                                  "Welcome Back ${FirebaseAuth.instance.currentUser!.displayName} !",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 30,
                                      color: Colors.white),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(15),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color.fromARGB(
                                          255, 11, 68, 37)),
                                  child: Row(
                                    children: [
                                      LottieBuilder.asset(
                                        'assets/banner.json',
                                        height: 175,
                                      ),
                                      Expanded(
                                          child: Text(
                                        'Expand Your Knowledge by Exploring and test with QuiGo',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      )),
                                      const SizedBox(width: 10)
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        QuizListWithCategory(
                            general: general,
                            category: 'general',
                            categoryName: 'General'),
                        QuizListWithCategory(
                            general: trivia,
                            category: 'trivia',
                            categoryName: 'Trivia'),
                      ],
                    ),
                  ),
                ),
    );
  }
}

class QuizListWithCategory extends StatelessWidget {
  const QuizListWithCategory({
    super.key,
    required this.general,
    required this.category,
    required this.categoryName,
  });

  final Map general;
  final String category;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            categoryName,
            style: headline,
          ),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width - 30,
                maxHeight: MediaQuery.sizeOf(context).height * .25),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: general.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(NavigatorConst.quiz, arguments: {
                    "name": general.keys.toList()[index],
                    "questions": general[general.keys.toList()[index]]
                        ['questions'],
                    'docName': category
                  });
                },
                child: Card.filled(
                  elevation: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: general[general.keys.toList()[index]]['image'] ==
                                null
                            ? Image.asset('assets/mylogo.png')
                            : CachedNetworkImage(
                                imageUrl: general[general.keys.toList()[index]]
                                    ['image']),
                      ),
                      Text(general.keys.toList()[index]),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => QuizLeaderboard(
                                      name: general.keys.toList()[index],
                                      leaderboard:
                                          general[general.keys.toList()[index]]
                                                  ['leaderBoards'] ??
                                              [],
                                    )));
                          },
                          style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              // minimumSize: Size.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Text("Leaderboard"))
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
