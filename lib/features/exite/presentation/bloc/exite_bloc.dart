import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'exite_event.dart';
part 'exite_state.dart';

class ExiteBloc extends Bloc<ExiteEvent, ExiteState> {
  ExiteBloc() : super(ExiteInitial()) {
    on<ExiteEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
