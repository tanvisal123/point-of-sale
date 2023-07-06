import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:point_of_sale/src/controllers/check_open_shift_controller.dart';
import 'package:point_of_sale/src/controllers/open_shift_controller.dart';
import 'package:point_of_sale/src/models/open_shift_modal.dart';

part 'open_shift_event.dart';
part 'open_shift_state.dart';

class OpenShiftBloc extends Bloc<OpenShiftEvent, OpenShiftState> {
  OpenShiftBloc({@required this.ip}) : super(OpenShiftInitial()) {
    //! Bloc new version
    on<OpenShiftEvent>((event, emit) async {
      emit(OpenShiftLoading());
      try {
        var _selectOpenShift = [];
        var _getOpenShift = await OpenShiftController.checkOpenShift(ip);
        _selectOpenShift = await CheckOpenShiftController().selectOpenShift();
        if (_selectOpenShift.isEmpty || _selectOpenShift == null) {
          print('Select OpenShift Null');
          if (_getOpenShift.isEmpty || _getOpenShift == null) {
            print('Get OpenShift Null');
          } else {
            var _openShift = _getOpenShift.first;
            await CheckOpenShiftController().insertOpenShift(
              OpenShiftModel(
                id: _openShift.id,
                dateIn: _openShift.dateIn,
                timeIn: _openShift.timeIn,
                branchId: _openShift.branchId,
                userId: _openShift.userId,
                localCurrencyId: _openShift.localCurrencyId,
                sysCurrencyId: _openShift.sysCurrencyId,
                cashAmountSys: _openShift.cashAmountSys,
                localSetRate: _openShift.localSetRate,
                open: _openShift.open,
                transFrom: _openShift.transFrom,
              ),
            );
          }
        } else {
          print('Select OpenShift Not Null');
          if (_getOpenShift.isEmpty || _getOpenShift == null) {
            print('Get OpenShift Null');
          } else {
            var _openShift = _getOpenShift.first;
            await CheckOpenShiftController().updateOpenShift(
              OpenShiftModel(
                id: _openShift.id,
                dateIn: _openShift.dateIn,
                timeIn: _openShift.timeIn,
                branchId: _openShift.branchId,
                userId: _openShift.userId,
                localCurrencyId: _openShift.localCurrencyId,
                sysCurrencyId: _openShift.sysCurrencyId,
                cashAmountSys: _openShift.cashAmountSys,
                localSetRate: _openShift.localSetRate,
                open: _openShift.open,
                transFrom: _openShift.transFrom,
              ),
            );
          }
        }
        _selectOpenShift = await CheckOpenShiftController().selectOpenShift();
        emit(OpenShiftLoaded(openShiftList: _selectOpenShift));
      } catch (e) {
        print('OpenShift Error = $e');
        emit(OpenShiftError(error: e.toString()));
      }
    });
  }

  final String ip;
//! Bloc Old version
  // @override
  // Stream<OpenShiftState> mapEventToState(OpenShiftEvent event) async* {
  //   yield OpenShiftLoading();
  //   try {
  //     var _selectOpenShift = [];
  //     var _getOpenShift = await OpenShiftController.checkOpenShift(ip);
  //     _selectOpenShift = await CheckOpenShiftController().selectOpenShift();
  //     if (_selectOpenShift.isEmpty || _selectOpenShift == null) {
  //       print('Select OpenShift Null');
  //       if (_getOpenShift.isEmpty || _getOpenShift == null) {
  //         print('Get OpenShift Null');
  //       } else {
  //         var _openShift = _getOpenShift.first;
  //         await CheckOpenShiftController().insertOpenShift(
  //           OpenShiftModel(
  //             id: _openShift.id,
  //             dateIn: _openShift.dateIn,
  //             timeIn: _openShift.timeIn,
  //             branchId: _openShift.branchId,
  //             userId: _openShift.userId,
  //             localCurrencyId: _openShift.localCurrencyId,
  //             sysCurrencyId: _openShift.sysCurrencyId,
  //             cashAmountSys: _openShift.cashAmountSys,
  //             localSetRate: _openShift.localSetRate,
  //             open: _openShift.open,
  //             transFrom: _openShift.transFrom,
  //           ),
  //         );
  //       }
  //     } else {
  //       print('Select OpenShift Not Null');
  //       if (_getOpenShift.isEmpty || _getOpenShift == null) {
  //         print('Get OpenShift Null');
  //       } else {
  //         var _openShift = _getOpenShift.first;
  //         await CheckOpenShiftController().updateOpenShift(
  //           OpenShiftModel(
  //             id: _openShift.id,
  //             dateIn: _openShift.dateIn,
  //             timeIn: _openShift.timeIn,
  //             branchId: _openShift.branchId,
  //             userId: _openShift.userId,
  //             localCurrencyId: _openShift.localCurrencyId,
  //             sysCurrencyId: _openShift.sysCurrencyId,
  //             cashAmountSys: _openShift.cashAmountSys,
  //             localSetRate: _openShift.localSetRate,
  //             open: _openShift.open,
  //             transFrom: _openShift.transFrom,
  //           ),
  //         );
  //       }
  //     }
  //     _selectOpenShift = await CheckOpenShiftController().selectOpenShift();
  //     yield OpenShiftLoaded(openShiftList: _selectOpenShift);
  //   } catch (e) {
  //     print('OpenShift Error = $e');
  //     yield OpenShiftError(error: e.toString());
  //   }
  // }
}
