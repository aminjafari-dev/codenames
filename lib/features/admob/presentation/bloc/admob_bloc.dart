import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'admob_event.dart';
part 'admob_state.dart';

class AdmobBloc extends Bloc<AdmobEvent, AdmobState> {
  AdmobBloc() : super(AdmobInitial()) {
    on<AdmobEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
