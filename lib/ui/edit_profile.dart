import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz/utils/const.dart';
import 'package:quiz/utils/styles.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.db, required this.userData});
  final DocumentReference db;
  final Map userData;
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController =
      TextEditingController(text: FirebaseAuth.instance.currentUser!.email!);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile"), centerTitle: true),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  // padding: EdgeInsets.all(4),
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        'assets/avatars/${widget.userData['profile']}.jpg',
                        fit: BoxFit.cover,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton.filled(
                    color: primaryColor,
                    onPressed: () async {
                      final profile = await showModalBottomSheet(
                        context: context,
                        builder: (context) => SelectProfilePic(),
                      );
                      if (profile != null) {
                        showLoadingPopup(context, "Updating profile pic");
                        await widget.db.update({'profile': profile});
                        widget.userData.clear();
                        widget.userData
                            .addAll((await widget.db.get()).data()! as Map);
                        setState(() {});
                        Navigator.of(context).pop();
                      }
                    },
                    icon: Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            CustomField(controller: nameController, label: 'Name'),
            const SizedBox(height: 15),
            CustomField(
                controller: emailController, label: 'Email', readOnly: true),
            const SizedBox(height: 15),
            CustomField(
                controller: passwordController,
                label: 'New Password(optional)'),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                    onPressed: () async {
                      showLoadingPopup(context, 'Updating...');
                      await FirebaseAuth.instance.currentUser!
                          .updateDisplayName(nameController.text);
                      if (passwordController.text.isNotEmpty) {
                        await FirebaseAuth.instance.currentUser!
                            .updateDisplayName(passwordController.text);
                      }
                      await widget.db.update({'name': nameController.text});
                      widget.userData['name'] = nameController.text;
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: primaryColor),
                    child: Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    )),
              ),
            )
          ],
        ),
      )),
    );
  }
}

class SelectProfilePic extends StatelessWidget {
  const SelectProfilePic({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .5),
      child: GridView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: 20,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            Navigator.of(context).pop(index + 1);
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.all(4),
            // height: 100,
            // width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  'assets/avatars/${index + 1}.jpg',
                  fit: BoxFit.cover,
                )),
          ),
        ),
      ),
    );
  }
}

class CustomField extends StatelessWidget {
  const CustomField(
      {super.key,
      required this.controller,
      required this.label,
      this.readOnly = false});
  final TextEditingController controller;
  final String label;
  final bool readOnly;
  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      controller: controller,
      decoration: InputDecoration(
          label: Text(label),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: primaryColor))),
    );
  }
}
