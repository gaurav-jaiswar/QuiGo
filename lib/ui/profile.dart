import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz/ui/about.dart';
import 'package:quiz/ui/edit_profile.dart';
import 'package:quiz/ui/leaderboards.dart';
import 'package:quiz/utils/const.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Map userData;
  final db = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.email);
  bool loading = true;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    userData = (await db.get()).data() ?? {};
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: loading
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(4),
                    height: 200,
                    width: 200,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          'assets/avatars/${userData['profile'] ?? 1}.jpg',
                          fit: BoxFit.cover,
                        )),
                  ),
                  Text(
                    userData['name'],
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 250, 236, 198),
                        border: Border.all(color: Colors.black)),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person_outline_rounded),
                          title: Text('Edit Profile'),
                          onTap: () async {
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    EditProfile(db: db, userData: userData)));
                            setState(() {});
                          },
                        ),
                        const Divider(
                          indent: 10,
                          endIndent: 10,
                          height: 1,
                        ),
                        ListTile(
                          leading: const Icon(Icons.leaderboard_outlined),
                          title: Text('Leader Boards'),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    Leaderboards(userData: userData)));
                          },
                        ),
                        // ListTile(
                        //   title: Text(''),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 250, 236, 198),
                        border: Border.all(color: Colors.black)),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.info_outline),
                          title: Text('About'),
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const AboutPage())),
                        ),
                        Divider(
                          indent: 10,
                          endIndent: 10,
                          height: 2,
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout_outlined),
                          title: Text('Logout'),
                          onTap: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                NavigatorConst.login, (r) => false);
                          },
                        ),
                        // ListTile(
                        //   title: Text(''),
                        // ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
