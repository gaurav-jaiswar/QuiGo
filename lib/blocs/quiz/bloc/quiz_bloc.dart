import 'package:bloc/bloc.dart';
part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizPageState> {
  final String docName;
  final String quizName;
  QuizBloc(List questions, this.docName, this.quizName)
      : super(QuizPageState(questions, 0)) {
    on<Submit>((event, emit) {
      emit(state.copyWith());
    });
    on<Prev>((event, emit) {
      emit(state.prev());
    });
  }
}

List<String> myList = [
  'Question 1',
  'Question 2',
  'Question 3',
  'Question 4',
  'Question 5',
  'Question 6',
  'Question 7',
  'Question 8',
  'Question 9',
  'Question 10'
];
