import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_of_sale/src/controllers/display_currency_controller.dart';
import 'package:point_of_sale/src/models/display_currency_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DisCurrencyEvent extends Equatable {
  const DisCurrencyEvent();
}

class GetDisCurrency extends DisCurrencyEvent {
  @override
  List<Object> get props => [];
}
//-------------end event-------------

abstract class DisCurrencyState extends Equatable {
  const DisCurrencyState();
}

class DisCurrencyInitial extends DisCurrencyState {
  const DisCurrencyInitial();
  @override
  List<Object> get props => [];
}

class DisCurrencyLoading extends DisCurrencyState {
  const DisCurrencyLoading();
  @override
  List<Object> get props => null;
}

class DisCurrencyLoaded extends DisCurrencyState {
  final List<DisplayCurrModel> disCurrency;
  const DisCurrencyLoaded(this.disCurrency);
  @override
  List<Object> get props => [disCurrency];
}

class DisCurrencyError extends DisCurrencyState {
  final String message;
  const DisCurrencyError(this.message);
  @override
  List<Object> get props => [message];
}
//----------end state--------------

class DisCurrencyBloc extends Bloc<DisCurrencyEvent, DisCurrencyState> {
  DisCurrencyBloc(DisCurrencyState initialState) : super(initialState) {
    on<DisCurrencyEvent>((event, emit) async {
      if (event is GetDisCurrency) {
        try {
          emit(DisCurrencyLoading());
          var _sp = await SharedPreferences.getInstance();
          var _ip = _sp.getString('ip');
          final disCur = await DisplayCurrController.getDisplayCurr(_ip);
          emit(DisCurrencyLoaded(disCur));
          if (disCur.isEmpty) {
            emit(DisCurrencyError("Price list is empty !"));
          }
        } catch (_) {
          emit(
              DisCurrencyError("Failed to fetch data. is your device online?"));
        }
      }
    });
  }

  DisCurrencyState get initialState => DisCurrencyInitial();

  // @override
  // Stream<DisCurrencyState> mapEventToState(DisCurrencyEvent event) async* {
  //   if (event is GetDisCurrency) {
  //     try {
  //       yield DisCurrencyLoading();
  //       var _sp = await SharedPreferences.getInstance();
  //       var _ip = _sp.getString('ip');
  //       final disCur = await DisplayCurrController.getDisplayCurr(_ip);
  //       yield DisCurrencyLoaded(disCur);
  //       if (disCur.isEmpty) {
  //         yield DisCurrencyError("Price list is empty !");
  //       }
  //     } catch (_) {
  //       yield DisCurrencyError("Failed to fetch data. is your device online?");
  //     }
  //   }
  // }
}
