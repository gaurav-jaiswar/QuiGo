import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/quiz/bloc/quiz_bloc.dart';

class Quizpage extends StatelessWidget {
  const Quizpage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    return Scaffold(
      appBar: AppBar(
        title: Text(arguments['name']),
        centerTitle: true,
      ),
      body: BlocProvider(
          create: (context) => QuizBloc(
              arguments['questions'], arguments['docName'], arguments['name']),
          child: BlocBuilder<QuizBloc, QuizPageState>(
            builder: (context, state) {
              return MyWidget(qlist: state.temp, questions: state.questions);
            },
          )),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key, required this.qlist, required this.questions});
  final List<Map<String, dynamic>> qlist;
  final List questions;

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));
  // @override
  // void initState() {
  //   super.initState();
  //   controller.addStatusListener((status) {
  //     if (status.name == 'completed') {
  //       controller.animateBack(0, duration: const Duration(milliseconds: 1));
  //       context.read<QuizBloc>().add(Submit(selected));
  //       selected = null;
  //     }
  //   });
  // }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int score = 0;
    int answered = 0;
    int correct = 0;
    for (var question in widget.questions) {
      if (question['answer'] == question['answered']) {
        score = (score + question['points']).toInt();
        correct++;
      }
      if (question['answered'] != null) {
        answered++;
      }
    }
    List<Widget> temp = [
      Padding(
        padding: EdgeInsets.fromLTRB(20.0, 20, 20, 25),
        child: Card(
          elevation: 1,
          child: Center(
              child: Text(
                  "Answered: $answered / ${widget.questions.length}\nCorrect: $correct\nTotal Score: $score")),
        ),
      )
    ];
    temp.addAll(widget.qlist.map((e) => QuestionCard(
        i: e['i'],
        q: e['q'],
        j: e['j'],
        questions: widget.questions,
        controller: controller)));
    return Column(
      children: [
        Expanded(child: Stack(children: temp)),
        if (widget.qlist.isNotEmpty)
          BlocBuilder<QuizBloc, QuizPageState>(
            builder: (context, state) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (widget.qlist.last['j'] != 0)
                  ElevatedButton(
                      onPressed: () {
                        context.read<QuizBloc>().add(Prev());
                        controller.reverse(from: 1);
                      },
                      child: Text('Previous')),
                if (widget.qlist.last['j'] != widget.questions.length - 1)
                  ElevatedButton(
                      onPressed: () {
                        // controller.reverse();
                        controller.forward().whenComplete(() {
                          context.read<QuizBloc>().add(Submit());
                          controller.reset();
                        });
                      },
                      child: Text('   Next   ')),
              ],
            ),
          ),
        const SizedBox(height: 20)
      ],
    );
  }
}

class QuestionCard extends StatefulWidget {
  const QuestionCard(
      {super.key,
      required this.i,
      required this.q,
      required this.controller,
      required this.j,
      required this.questions});
  final int i;
  final Map q;
  final int j;
  final List questions;
  final AnimationController controller;

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  String? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.questions[widget.j]['answered'];
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant QuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    selected = widget.questions[widget.j]['answered'];
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: widget.i == 3
          ? Tween<Offset>(begin: Offset.zero, end: const Offset(1.5, 0))
              .animate(CurvedAnimation(
                  parent: widget.controller, curve: Curves.easeOut))
          : Tween<Offset>(begin: Offset.zero, end: const Offset(0, 0.013))
              .animate(CurvedAnimation(
                  parent: widget.controller, curve: Curves.easeOut)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20 + (8.0 * widget.i), 20, 50 - (8.0 * widget.i)),
        child: Card(
            elevation: 20,
            child: ListView.builder(
                itemCount: (2 + widget.q['options'].length).toInt(),
                itemBuilder: (context, index) {
                  return index == 0
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child:
                              Text("${widget.j + 1}. ${widget.q['question']}"),
                        )
                      : index == (2 + widget.q['options'].length - 1).toInt()
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: TextButton(
                                  onPressed: () {
                                    widget.questions[widget.j]['answered'] =
                                        selected;
                                    widget.controller
                                        .forward()
                                        .whenComplete(() {
                                      widget.controller.reset();
                                      context.read<QuizBloc>().add(Submit());
                                      selected = null;
                                    });
                                    if (widget.j ==
                                        widget.questions.length - 1) {
                                      int score = 0;
                                      int totalScore = 0;
                                      for (var question in widget.questions) {
                                        if (question['answer'] ==
                                            question['answered']) {
                                          score = (score + question['points'])
                                              .toInt();
                                          totalScore =
                                              (totalScore + question['points'])
                                                  .toInt();
                                        }
                                      }
                                      //update in quiz
                                      FirebaseFirestore.instance
                                          .collection('quiz')
                                          .doc(context.read<QuizBloc>().docName)
                                          .update({
                                        "${context.read<QuizBloc>().quizName}.leaderBoards":
                                            FieldValue.arrayUnion([
                                          {
                                            FirebaseAuth.instance.currentUser!
                                                .email: score
                                          }
                                        ])
                                      });
                                      //update in user
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.email!)
                                          .update({
                                        "leaderBoards": FieldValue.arrayUnion([
                                          {
                                            context.read<QuizBloc>().quizName:
                                                "$score / $totalScore"
                                          }
                                        ])
                                      });
                                    }
                                    // selected = null;
                                  },
                                  child: const Text(
                                    "Submit",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue),
                                  )),
                            )
                          : RadioListTile<String>(
                              title: Text(widget.q['options'][index - 1]),
                              value: widget.q['options'][index - 1],
                              groupValue: selected,
                              onChanged: (String? value) {
                                setState(() {
                                  selected = value;
                                });
                              },
                            );
                })),
      ),
    );
  }
}
