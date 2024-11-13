import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'spymaster_event.dart';
part 'spymaster_state.dart';

class SpymasterBloc extends Bloc<SpymasterEvent, SpymasterState> {
  SpymasterBloc() : super(SpymasterInitial()) {
    on<SpymasterEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
