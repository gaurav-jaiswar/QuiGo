part of 'quiz_bloc.dart';

abstract class QuizEvent {}

final class Submit extends QuizEvent {
  // int? selected;
  // Submit(this.selected);
}

class Prev extends QuizEvent {}
