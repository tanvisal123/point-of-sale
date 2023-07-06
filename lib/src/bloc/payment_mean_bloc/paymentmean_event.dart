part of 'paymentmean_bloc.dart';

abstract class PaymentmeanEvent extends Equatable {
  const PaymentmeanEvent();

  @override
  List<Object> get props => [];
}

class GetPaymenyMeanEvent extends PaymentmeanEvent {}
