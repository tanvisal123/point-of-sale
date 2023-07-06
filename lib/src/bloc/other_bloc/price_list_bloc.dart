import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_of_sale/src/controllers/price_list_controller.dart';
import 'dart:async';
import 'package:point_of_sale/src/models/price_list_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PriceListEvent extends Equatable {
  const PriceListEvent();
}

class GetPriceList extends PriceListEvent {
  @override
  List<Object> get props => null;
}

//-------------end event----------------
abstract class PriceListState extends Equatable {
  const PriceListState();
}

class PriceListInitial extends PriceListState {
  const PriceListInitial();
  @override
  List<Object> get props => [];
}

class PriceListLoading extends PriceListState {
  const PriceListLoading();
  @override
  List<Object> get props => null;
}

class PriceListLoaded extends PriceListState {
  final List<PriceList> priceList;
  const PriceListLoaded(this.priceList);
  @override
  List<Object> get props => [priceList];
}

class PriceListError extends PriceListState {
  final String message;
  const PriceListError(this.message);
  @override
  List<Object> get props => [message];
}
//---------------end state--------------

class PriceListBloc extends Bloc<PriceListEvent, PriceListState> {
  PriceListBloc(PriceListState initialState) : super(initialState) {
    on<PriceListEvent>((event, emit) async {
      if (event is GetPriceList) {
        try {
          var _sp = await SharedPreferences.getInstance();
          var _ip = _sp.getString('ip');
          emit(PriceListLoading());
          final priceList = await PriceListController.eachPriceList(_ip);
          emit(PriceListLoaded(priceList));
          if (priceList.isEmpty) emit(PriceListError("Price list is empty !"));
        } catch (_) {
          emit(PriceListError("Failed to fetch data. is your device online?"));
        }
      }
    });
  }

  PriceListState get initialState => PriceListInitial();

  // @override
  // Stream<PriceListState> mapEventToState(PriceListEvent event) async* {
  //   if (event is GetPriceList) {
  //     try {
  //       var _sp = await SharedPreferences.getInstance();
  //       var _ip = _sp.getString('ip');
  //       yield PriceListLoading();
  //       final priceList = await PriceListController.eachPriceList(_ip);
  //       yield PriceListLoaded(priceList);
  //       if (priceList.isEmpty) yield PriceListError("Price list is empty !");
  //     } catch (_) {
  //       yield PriceListError("Failed to fetch data. is your device online?");
  //     }
  //   }
  // }
}
