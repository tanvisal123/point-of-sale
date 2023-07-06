import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:point_of_sale/src/controllers/display_currency_controller.dart';
import 'package:point_of_sale/src/models/display_currency_modal.dart';
part 'displaycurr_event.dart';
part 'displaycurr_state.dart';

class DisplaycurrBloc extends Bloc<DisplaycurrEvent, DisplaycurrState> {
  DisplaycurrBloc({@required this.ip}) : super(DisplaycurrInitial()) {
    on<DisplaycurrEvent>((event, emit) async {
      if (event is GetDisplayCurrEvent) {
        emit(DisplaycurrLoading());
        try {
          List<DisplayCurrModel> _selectDisplayCurr = [];
          List<DisplayCurrModel> _getDisplayCurr =
              await DisplayCurrController.getDisplayCurr(ip);
          _selectDisplayCurr =
              await DisplayCurrController().selectDisplayCurr();
          if (_selectDisplayCurr.isEmpty || _selectDisplayCurr == null) {
            print('DisplayCurr Null');
            if (_getDisplayCurr.isEmpty || _getDisplayCurr == null) {
              print('GetDisplayCurr Null');
            } else {
              await DisplayCurrController().insertDisplayCurr(DisplayCurrModel(
                id: _getDisplayCurr.first.id,
                altCurr: _getDisplayCurr.first.altCurr,
                baseCurr: _getDisplayCurr.first.baseCurr,
                rate: _getDisplayCurr.first.rate,
              ));
            }
          } else {
            print('DisplayCurr Not Null');
            if (_getDisplayCurr.isEmpty || _getDisplayCurr == null) {
              print('GetDisplayCurr Null');
            } else {
              await DisplayCurrController().updateDisplayCurr(DisplayCurrModel(
                id: _getDisplayCurr.first.id,
                altCurr: _getDisplayCurr.first.altCurr,
                baseCurr: _getDisplayCurr.first.baseCurr,
                rate: _getDisplayCurr.first.rate,
              ));
            }
          }
          _selectDisplayCurr =
              await DisplayCurrController().selectDisplayCurr();
          emit(DisplaycurrLoaded(displayCurrLs: _selectDisplayCurr));
        } catch (e) {
          print('DisplayCurr Error = $e');
          emit(DisplaycurrError(error: e.toString()));
        }
      }
    });
  }
  final String ip;

  // @override
  // Stream<DisplaycurrState> mapEventToState(DisplaycurrEvent event) async* {
  //   if (event is GetDisplayCurrEvent) {
  //     yield DisplaycurrLoading();
  //     try {
  //       List<DisplayCurrModel> _selectDisplayCurr = [];
  //       List<DisplayCurrModel> _getDisplayCurr =
  //           await DisplayCurrController.getDisplayCurr(ip);
  //       _selectDisplayCurr = await DisplayCurrController().selectDisplayCurr();
  //       if (_selectDisplayCurr.isEmpty || _selectDisplayCurr == null) {
  //         print('DisplayCurr Null');
  //         if (_getDisplayCurr.isEmpty || _getDisplayCurr == null) {
  //           print('GetDisplayCurr Null');
  //         } else {
  //           await DisplayCurrController().insertDisplayCurr(DisplayCurrModel(
  //             id: _getDisplayCurr.first.id,
  //             altCurr: _getDisplayCurr.first.altCurr,
  //             baseCurr: _getDisplayCurr.first.baseCurr,
  //             rate: _getDisplayCurr.first.rate,
  //           ));
  //         }
  //       } else {
  //         print('DisplayCurr Not Null');
  //         if (_getDisplayCurr.isEmpty || _getDisplayCurr == null) {
  //           print('GetDisplayCurr Null');
  //         } else {
  //           await DisplayCurrController().updateDisplayCurr(DisplayCurrModel(
  //             id: _getDisplayCurr.first.id,
  //             altCurr: _getDisplayCurr.first.altCurr,
  //             baseCurr: _getDisplayCurr.first.baseCurr,
  //             rate: _getDisplayCurr.first.rate,
  //           ));
  //         }
  //       }
  //       _selectDisplayCurr = await DisplayCurrController().selectDisplayCurr();
  //       yield DisplaycurrLoaded(displayCurrLs: _selectDisplayCurr);
  //     } catch (e) {
  //       print('DisplayCurr Error = $e');
  //       yield DisplaycurrError(error: e.toString());
  //     }
  //   }
  // }
}
