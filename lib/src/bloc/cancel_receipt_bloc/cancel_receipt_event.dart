part of 'cancel_receipt_bloc.dart';

abstract class CancelReceiptEvent {
  final String dateFrom;
  final String dateTo;

  CancelReceiptEvent(this.dateFrom, this.dateTo);
}

class GetCancelReceiptEvent extends CancelReceiptEvent {
  GetCancelReceiptEvent(String dateFrom, String dateTo)
      : super(dateFrom, dateTo);
}
