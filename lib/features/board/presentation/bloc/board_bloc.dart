import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'board_event.dart';
part 'board_state.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  BoardBloc() : super(BoardInitial()) {
    on<BoardEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
