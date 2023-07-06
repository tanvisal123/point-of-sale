part of 'paymentmean_bloc.dart';

abstract class PaymentmeanState extends Equatable {
  const PaymentmeanState();

  @override
  List<Object> get props => [];
}

class PaymentmeanInitial extends PaymentmeanState {}

class PaymentmeanLoading extends PaymentmeanState {}

class PaymentmeanLoaded extends PaymentmeanState {
  final List<PaymentMeanModel> paymentMeanList;

  PaymentmeanLoaded({@required this.paymentMeanList});
}

class PaymentmeanError extends PaymentmeanState {
  final String message;

  PaymentmeanError({@required this.message});
}
