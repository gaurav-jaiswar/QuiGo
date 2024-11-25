part of 'quiz_bloc.dart';

abstract class QuizState {}

final class QuizPageState extends QuizState {
  final List questions;
  final int answered;
  List<Map<String, dynamic>> temp = [];
  QuizPageState(this.questions, this.answered) {
    for (int i = 0; i < 4; i++) {
      int j = 3 + answered - i;
      if (0 <= j && j < questions.length) {
        temp.add(<String, dynamic>{'i': i, 'q': questions[j], 'j': j});
      }
      // QuestionCard(i: i, q: questions[j])
    }
  }

  QuizPageState copyWith() {
    return QuizPageState(questions, answered + 1);
  }
  QuizPageState prev() {
    return QuizPageState(questions, answered - 1);
  }
}

final class QuizCardState extends QuizState {}
