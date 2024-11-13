import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:codenames/index.dart';

class LandinBloc extends Bloc<LandinEvent, LandinState> {
  // todo: check singleton for logic in project
  // use GetIt for DI in projct
  static final LandinBloc _landinBlocSingleton = LandinBloc._internal();
  factory LandinBloc() {
    return _landinBlocSingleton;
  }
  
  LandinBloc._internal(): super(UnLandinState(0)){
    on<LandinEvent>((event, emit) {
      return emit.forEach<LandinState>(
        event.applyAsync(currentState: state, bloc: this),
        onData: (state) => state,
        onError: (error, stackTrace) {
          developer.log('$error', name: 'LandinBloc', error: error, stackTrace: stackTrace);
          return ErrorLandinState(0, error.toString());
        },
      );
    });
  }
  
  @override
  Future<void> close() async{
    // dispose objects
    await super.close();
  }

  @override
  LandinState get initialState => UnLandinState(0);

}
