import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz/utils/styles.dart';

class QuizLeaderboard extends StatefulWidget {
  const QuizLeaderboard(
      {super.key, required this.name, required this.leaderboard});
  final String name;
  final List leaderboard;

  @override
  State<QuizLeaderboard> createState() => _QuizLeaderboardState();
}

class _QuizLeaderboardState extends State<QuizLeaderboard> {
  bool loading = true;
  late Map users;

  @override
  void initState() {
    super.initState();
    loadUsersData();
  }

  void loadUsersData() async {
    users = {};
    if (widget.leaderboard.isEmpty) {
      return;
    }
    final temp =
        (await FirebaseFirestore.instance.collection('users').get()).docs;
    for (var user in temp) {
      users[user.id] = user.data();
    }
    widget.leaderboard.sort(
      (b, a) {
        return a.entries.first.value.compareTo(b.entries.first.value);
      },
    );
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: true,
      ),
      body: widget.leaderboard.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "This quiz is not attempted by anyone yet be the first member of this board",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: primaryColor),
                ),
              ),
            )
          : loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: widget.leaderboard.length,
                  itemBuilder: (context, index) {
                    final data =
                        widget.leaderboard[index].entries.first as MapEntry;
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 250, 236, 198),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black)),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            'assets/avatars/${users[data.key]['profile'] ?? 1}.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          users[data.key]['name'],
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                        trailing: Text(data.value.toString(),
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 18)),
                      ),
                    );
                  },
                ),
    );
  }
}
