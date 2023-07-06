import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:point_of_sale/src/controllers/receipt_contoller.dart';
import 'package:point_of_sale/src/models/receipt_model.dart';
import 'package:http/http.dart' as http;
part 'cancel_receipt_event.dart';
part 'cancel_receipt_state.dart';

class CancelReceiptBloc extends Bloc<CancelReceiptEvent, CancelReceiptState> {
  CancelReceiptBloc({@required this.ip}) : super(CancelReceiptInitial()) {
    on<CancelReceiptEvent>((event, emit) async {
      if (event is GetCancelReceiptEvent) {
        emit(CancelReceiptLoading('Loading...'));
        final response = await ReceiptController.getCancelReceipt(
            event.dateFrom, event.dateTo, index, ip);
        if (response is http.Response) {
          if (response.statusCode == 200) {
            print('Response = ${response.body}');
            emit(CancelReceiptSuccess(receiptModelFromJson(response.body)));
            index++;
          } else {
            emit(CancelReceiptError(response.body));
          }
        } else if (response is String) {
          emit(CancelReceiptError(response));
        }
      }
    });
  }

  int index = 1;
  bool isFetching = false;
  final String ip;

  // @override
  // Stream<CancelReceiptState> mapEventToState(CancelReceiptEvent event) async* {
  //   if (event is GetCancelReceiptEvent) {
  //     yield CancelReceiptLoading('Loading...');
  //     final response = await ReceiptController.getCancelReceipt(
  //         event.dateFrom, event.dateTo, index, ip);
  //     if (response is http.Response) {
  //       if (response.statusCode == 200) {
  //         print('Response = ${response.body}');
  //         yield CancelReceiptSuccess(receiptModelFromJson(response.body));
  //         index++;
  //       } else {
  //         yield CancelReceiptError(response.body);
  //       }
  //     } else if (response is String) {
  //       yield CancelReceiptError(response);
  //     }
  //   }
  // }
}
