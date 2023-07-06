import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:point_of_sale/src/controllers/payment_mean_controller.dart';
import 'package:point_of_sale/src/models/payment_means_modal.dart';
part 'paymentmean_event.dart';
part 'paymentmean_state.dart';

class PaymentmeanBloc extends Bloc<PaymentmeanEvent, PaymentmeanState> {
  final String ip;
  PaymentmeanBloc({this.ip}) : super(PaymentmeanInitial()) {
    on<PaymentmeanEvent>((event, emit) async {
      if (event is GetPaymenyMeanEvent) {
        emit(PaymentmeanLoading());
        try {
          List<PaymentMeanModel> _selectPaymentMeanList = [];
          _selectPaymentMeanList =
              await PaymentMeanController().selectPaymentMean();
          List<PaymentMeanModel> _getPaymentMeanList =
              await PaymentMeanController.getPaymenyMean(ip);
          if (_selectPaymentMeanList.isEmpty ||
              _selectPaymentMeanList == null) {
            print('Payment Null');
            if (_getPaymentMeanList.isEmpty || _getPaymentMeanList == null) {
              print('GetDisplayCurr Null');
            } else {
              await PaymentMeanController().insertPaymentMean(PaymentMeanModel(
                id: _getPaymentMeanList.first.id,
                type: _getPaymentMeanList.first.type,
              ));
            }
          } else {
            print('Payment Not Null');
            if (_getPaymentMeanList.isEmpty || _getPaymentMeanList == null) {
              print('GetDisplayCurr Null');
            } else {
              await PaymentMeanController().updatePaymentMean(
                PaymentMeanModel(
                  id: _getPaymentMeanList.first.id,
                  type: _getPaymentMeanList.first.type,
                ),
              );
            }
          }
          _selectPaymentMeanList =
              await PaymentMeanController().selectPaymentMean();
          emit(PaymentmeanLoaded(paymentMeanList: _selectPaymentMeanList));
        } catch (e) {
          emit(PaymentmeanError(message: e.toString()));
        }
      }
    });
  }

  // @override
  // Stream<PaymentmeanState> mapEventToState(PaymentmeanEvent event) async* {
  //   if (event is GetPaymenyMeanEvent) {
  //     yield PaymentmeanLoading();
  //     try {
  //       List<PaymentMeanModel> _selectPaymentMeanList = [];
  //       _selectPaymentMeanList =
  //           await PaymentMeanController().selectPaymentMean();
  //       List<PaymentMeanModel> _getPaymentMeanList =
  //           await PaymentMeanController.getPaymenyMean(ip);
  //       if (_selectPaymentMeanList.isEmpty || _selectPaymentMeanList == null) {
  //         print('Payment Null');
  //         if (_getPaymentMeanList.isEmpty || _getPaymentMeanList == null) {
  //           print('GetDisplayCurr Null');
  //         } else {
  //           await PaymentMeanController().insertPaymentMean(PaymentMeanModel(
  //             id: _getPaymentMeanList.first.id,
  //             type: _getPaymentMeanList.first.type,
  //           ));
  //         }
  //       } else {
  //         print('Payment Not Null');
  //         if (_getPaymentMeanList.isEmpty || _getPaymentMeanList == null) {
  //           print('GetDisplayCurr Null');
  //         } else {
  //           await PaymentMeanController().updatePaymentMean(
  //             PaymentMeanModel(
  //               id: _getPaymentMeanList.first.id,
  //               type: _getPaymentMeanList.first.type,
  //             ),
  //           );
  //         }
  //       }
  //       _selectPaymentMeanList =
  //           await PaymentMeanController().selectPaymentMean();
  //       yield PaymentmeanLoaded(paymentMeanList: _selectPaymentMeanList);
  //     } catch (e) {
  //       yield PaymentmeanError(message: e.toString());
  //     }
  //   }
  // }
}
