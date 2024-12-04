part of 'app_purchase_bloc.dart';

class AppPurchaseState extends Equatable {
  const AppPurchaseState({this.premiums,required this.loading});
  final PremiumTypeEnum? premiums;
  final bool loading;

  @override
  List<Object> get props => [
        {premiums}, loading,
      ];
}

// class AppPurchaseInitial extends AppPurchaseState {}

// class AppPurchaseLoading extends AppPurchaseState {}

// class AppPurchaseCompleted extends AppPurchaseState {}

// class AppPurchaseError extends AppPurchaseState {
//   final String message;

//   const AppPurchaseError(this.message);
// }
