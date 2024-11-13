part of 'board_bloc.dart';

abstract class BoardState extends Equatable {
  const BoardState();  

  @override
  List<Object> get props => [];
}
class BoardInitial extends BoardState {}
