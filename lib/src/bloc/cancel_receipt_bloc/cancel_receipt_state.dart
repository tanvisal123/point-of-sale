part of 'cancel_receipt_bloc.dart';

abstract class CancelReceiptState {}

class CancelReceiptInitial extends CancelReceiptState {}

class CancelReceiptLoading extends CancelReceiptState {
  final String message;
  CancelReceiptLoading(this.message);
}

class CancelReceiptSuccess extends CancelReceiptState {
  final List<ReceiptModel> receipts;

  CancelReceiptSuccess(this.receipts);
}

class CancelReceiptError extends CancelReceiptState {
  final String error;

  CancelReceiptError(this.error);
}
