import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_of_sale/src/controllers/warehouse_controller.dart';
import 'dart:async';
import 'package:point_of_sale/src/models/warehouse_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class WarehouseEvent extends Equatable {
  const WarehouseEvent();
}

class GetWarehouse extends WarehouseEvent {
  @override
  List<Object> get props => null;
}

abstract class WarehouseState extends Equatable {
  const WarehouseState();
}

class WarehouseInitial extends WarehouseState {
  const WarehouseInitial();
  @override
  List<Object> get props => [];
}

class WarehouseLoading extends WarehouseState {
  const WarehouseLoading();
  @override
  List<Object> get props => null;
}

class WarehouseLoaded extends WarehouseState {
  final List<Warehouse> warehouse;
  const WarehouseLoaded(this.warehouse);
  @override
  List<Object> get props => [warehouse];
}

class WarehouseError extends WarehouseState {
  final String message;
  const WarehouseError(this.message);
  @override
  List<Object> get props => [message];
}

class WarehouseBloc extends Bloc<WarehouseEvent, WarehouseState> {
  WarehouseBloc(WarehouseState initialState) : super(initialState) {
    on<WarehouseEvent>((event, emit) async {
      if (event is GetWarehouse) {
        try {
          var _sp = await SharedPreferences.getInstance();
          var _ip = _sp.getString('ip');
          emit(WarehouseLoading());
          final ware = await WarehouseController.eachWarehouse(_ip);
          emit(WarehouseLoaded(ware));
          if (ware.isEmpty) {
            emit(WarehouseError("Warehouse is empty !"));
          }
        } catch (_) {
          emit(WarehouseError("Failed to fetch data. is your device online?"));
        }
      }
    });
  }
  WarehouseState get initialState => WarehouseInitial();
}
