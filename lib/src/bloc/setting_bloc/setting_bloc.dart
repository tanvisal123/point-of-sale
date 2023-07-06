import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:point_of_sale/src/controllers/setting_controller.dart';
import 'package:point_of_sale/src/models/setting_modal.dart';
part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc({@required this.ip}) : super(SettingInitial()) {
    on<SettingEvent>((event, emit) async {
      if (event is GetSettingEvent) {
        emit(SettingLoading());
        try {
          List<SettingModel> _selectSetting = [];
          List<SettingModel> _getSetting =
              await SettingController.getSetting(ip);
          _selectSetting = await SettingController().selectSetting();
          if (_selectSetting.isEmpty || _selectSetting == null) {
            print('Setting Null');
            if (_getSetting.isEmpty || _getSetting == null) {
              print('Get Setting Null');
            } else {
              await SettingController().insertSetting(SettingModel(
                id: _getSetting.first.id,
                branchId: _getSetting.first.branchId,
                companyId: _getSetting.first.companyId,
                customerId: _getSetting.first.customerId,
                localCurrencyId: _getSetting.first.localCurrencyId,
                paymentMeansId: _getSetting.first.paymentMeansId,
                priceListId: _getSetting.first.priceListId,
                autoQueue: _getSetting.first.autoQueue,
                closeShift: _getSetting.first.closeShift,
                macAddress: _getSetting.first.macAddress ?? '',
                printCountReceipt: _getSetting.first.printCountReceipt,
                printLabel: _getSetting.first.printLabel,
                printReceiptOrder: _getSetting.first.printReceiptOrder,
                printReceiptTender: _getSetting.first.printReceiptTender,
                printer: _getSetting.first.printer ?? '',
                queueCount: _getSetting.first.queueCount,
                rateIn: _getSetting.first.rateIn,
                rateOut: _getSetting.first.rateOut,
                receiptSize: _getSetting.first.receiptSize,
                receiptTemplate: _getSetting.first.receiptTemplate,
                sysCurrencyId: _getSetting.first.sysCurrencyId,
                vatAble: _getSetting.first.vatAble,
                vatNum: _getSetting.first.vatNum ?? '',
                warehouseId: _getSetting.first.warehouseId,
                wifi: _getSetting.first.wifi,
              ));
            }
          } else {
            print('Setting Not Null');
            if (_getSetting.isEmpty || _getSetting == null) {
              print('Get Setting Null');
            } else {
              await SettingController().updateSetting(SettingModel(
                id: _getSetting.first.id,
                branchId: _getSetting.first.branchId,
                companyId: _getSetting.first.companyId,
                customerId: _getSetting.first.customerId,
                localCurrencyId: _getSetting.first.localCurrencyId,
                paymentMeansId: _getSetting.first.paymentMeansId,
                priceListId: _getSetting.first.priceListId,
                autoQueue: _getSetting.first.autoQueue,
                closeShift: _getSetting.first.closeShift,
                macAddress: _getSetting.first.macAddress ?? '',
                printCountReceipt: _getSetting.first.printCountReceipt,
                printLabel: _getSetting.first.printLabel,
                printReceiptOrder: _getSetting.first.printReceiptOrder,
                printReceiptTender: _getSetting.first.printReceiptTender,
                printer: _getSetting.first.printer ?? '',
                queueCount: _getSetting.first.queueCount,
                rateIn: _getSetting.first.rateIn,
                rateOut: _getSetting.first.rateOut,
                receiptSize: _getSetting.first.receiptSize,
                receiptTemplate: _getSetting.first.receiptTemplate,
                sysCurrencyId: _getSetting.first.sysCurrencyId,
                vatAble: _getSetting.first.vatAble,
                vatNum: _getSetting.first.vatNum ?? '',
                warehouseId: _getSetting.first.warehouseId,
                wifi: _getSetting.first.wifi,
              ));
            }
          }
          _selectSetting = await SettingController().selectSetting();
          emit(SettingLoaded(settingList: _selectSetting));
        } catch (e) {
          print('Setting Error = $e');
          emit(SettingError(error: e.toString()));
        }
      }
    });
  }
  final String ip;
}
