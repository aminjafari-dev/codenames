import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'premium_state.dart';

class PremiumCubit extends Cubit<PremiumState> {
  PremiumCubit() : super(PremiumInitial());
}
