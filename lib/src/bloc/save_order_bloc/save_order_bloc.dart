import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:point_of_sale/src/controllers/fetchorder_controller.dart';
import 'package:point_of_sale/src/controllers/post_order_to_server.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
part 'save_order_event.dart';
part 'save_order_state.dart';

class SaveOrderBlocBloc extends Bloc<SaveOrderBlocEvent, SaveOrderBlocState> {
  SaveOrderBlocBloc() : super(SaveOrderBlocInitial()) {
    on<GetSaveOrderEvent>((event, emit) async {
      FetchOrderModel fetchOrderModel;
      List<Order> order = [];
      fetchOrderModel = await FetchOrderController()
          .getFetchOrder(event.ip, 0, event.orderId, 0, false);
      order = fetchOrderModel.orders;
      try {
        if (order.isNotEmpty) {
          emit(SaveOrderLoaded(orders: order));
        } else {
          emit(SaveOrderError(message: "No Data"));
        }
      } catch (e) {
        emit(SaveOrderError(message: e.toString()));
      }
    });
    on<DeteleSaveOrder>(((event, emit) async {
      await PostOrder().deteleSaveOrder(event.orderId, event.ip);
    }));
  }
}
