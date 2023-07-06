import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:point_of_sale/src/controllers/tax_controller.dart';
import 'package:point_of_sale/src/models/tax_modal.dart';
part 'tax_event.dart';
part 'tax_state.dart';

class TaxBloc extends Bloc<TaxEvent, TaxState> {
  TaxBloc({@required this.ip}) : super(TaxInitial()) {
    on<TaxEvent>((event, emit) async {
      if (event is GetTaxEvent) {
        emit(TaxLoading());
        try {
          List<TaxModel> _selectTax = [];
          List<TaxModel> _getTax = await TaxController.getTax(ip);
          _selectTax = await TaxController().selectTax();
          if (_selectTax.isEmpty || _selectTax == null) {
            print('Tax is Null');
            if (_getTax.isEmpty || _getTax == null) {
              print('Get Tax is null');
            } else {
              await TaxController().insertTax(TaxModel(
                id: _getTax.first.id,
                name: _getTax.first.name,
                rate: _getTax.first.rate,
              ));
            }
          } else {
            print('Tax is not null');
            if (_getTax.isEmpty || _getTax == null) {
              print('Get Tax is null');
            } else {
              await TaxController().updateTax(TaxModel(
                id: _getTax.first.id,
                name: _getTax.first.name,
                rate: _getTax.first.rate,
              ));
            }
          }
          _selectTax = await TaxController().selectTax();
          emit(TaxLoaded(taxList: _selectTax));
        } catch (e) {
          print('Tax Error : $e');
          emit(TaxError(error: e.toString()));
        }
      }
    });
  }
  final String ip;
}
