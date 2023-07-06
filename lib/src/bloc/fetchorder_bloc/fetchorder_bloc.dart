import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/src/controllers/order_detail_controller.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
part 'fetchorder_event.dart';
part 'neworder_state.dart';

class FetchOrderBloc extends Bloc<FetchOrderEvent, FetchOrderState> {
  final String ip;
  FetchOrderBloc({@required this.ip}) : super(NeworderInitial()) {
    on<AddNewOrederEvent>((event, emit) async {
      double countQty = 0;
      double subTotal = 0;
      double grandTotal = 0;
      double printQty = 0;
      if (event is AddNewOrederEvent) {
        List<OrderDetailModel> listOrder =
            event.fetchOrderModel.order.orderDetail;
        OrderDetailModel lineItem;
        Order order = event.fetchOrderModel.order;
        // print("order id : ${order.orderId}");
        print("order id: ${event.orderId}");
        if (listOrder.isEmpty) {
          lineItem = await OrderDetialController()
              .getOrderDetail(ip, event.saleId, event.orderId);
          listOrder.add(lineItem);
          order.subTotal = sumSubtotal(order);
          order.grandTotal = subGrandTotal(order);
        } else {
          lineItem = listOrder.firstWhere(
              (element) => element.lineId == event.saleId.toString(),
              orElse: () => null);
          if (lineItem == null) {
            lineItem = await OrderDetialController()
                .getOrderDetail(ip, event.saleId, event.orderId);
            listOrder.add(lineItem);
            order.subTotal = sumSubtotal(order);
            order.grandTotal = subGrandTotal(order);
          } else {
            if (lineItem.orderDetailId > 0) {
              lineItem.qty++;
            } else {
              lineItem.printQty++;
              lineItem.qty = lineItem.printQty;
            }
            lineItem.total = sumLineItem(lineItem);
            order.subTotal = sumSubtotal(order);
            order.grandTotal = subGrandTotal(order);
          }
          order.subTotal = sumSubtotal(order);
          order.grandTotal = subGrandTotal(order);
          //update order
        }
        countQty = sumItemQty(listOrder);
        StateNewOrder stateNewOrder = StateNewOrder(
            subTotal: subTotal,
            coutQty: countQty,
            grandTotal: grandTotal,
            lineItem: lineItem,
            fetchOrderModel: event.fetchOrderModel,
            printQty: printQty);
        emit(stateNewOrder);
        emit(NeworderLoaded(stateOrder: stateNewOrder));
      }
    });
    on<UpdateOrderEvent>((event, emit) async {
      double countQty = 0;
      countQty = sumItemQty(event.fetchOrderModel.order.orderDetail);
      StateNewOrder stateNewOrder = StateNewOrder(
          subTotal: 0,
          coutQty: countQty,
          grandTotal: 0,
          lineItem: event.orderDetailModel,
          fetchOrderModel: event.fetchOrderModel,
          printQty: 0);
      emit(stateNewOrder);
      emit(NeworderLoaded(stateOrder: stateNewOrder));
      stateNewOrder.show();
    });

    on<DeleteNewOrderEvent>((event, emit) {
      emit(NeworderInitial());
    });
  }
  static double sumLineItem(OrderDetailModel orderDetail) {
    return orderDetail.qty *
        orderDetail.unitPrice *
        (1 - orderDetail.discountRate / 100);
  }

  static double sumSubtotal(Order order) {
    double subtotal = 0;
    for (var item in order.orderDetail) {
      subtotal += sumLineItem(item);
    }
    order.subTotal = subtotal;
    return subtotal;
  }

  static double subGrandTotal(Order order) {
    double grandTotal = 0.0;
    grandTotal = order.subTotal * (1 - order.discountRate / 100);
    order.grandTotal = grandTotal;
    return grandTotal;
  }

  static double sumItemQty(List<OrderDetailModel> list) {
    double qty = 0;
    if (list.isNotEmpty || list != null) {
      for (var temp in list) {
        qty += temp.qty;
      }
    } else {
      qty = 0;
    }
    return qty;
  }
}
