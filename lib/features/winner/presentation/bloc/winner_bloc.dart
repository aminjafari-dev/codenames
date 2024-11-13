import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'winner_event.dart';
part 'winner_state.dart';

class WinnerBloc extends Bloc<WinnerEvent, WinnerState> {
  WinnerBloc() : super(WinnerInitial()) {
    on<WinnerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
