import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:point_of_sale/src/controllers/order_detail_controller.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  String ip;
  final OrderDetialController orderDetialController = OrderDetialController();
  OrderBloc({this.ip}) : super(OrderInitial()) {
    on<AddOrderEvent>(_onAdddOrder);
    on<UpdateOrderEvent>(_onUpdateOrder);
    on<DeleteOrderEvent>((event, emit) {
      emit(OrderInitial());
    });
  }
  void _onAdddOrder(AddOrderEvent event, Emitter<OrderState> emit) async {
    var prefs = await SharedPreferences.getInstance();
    ip = prefs.getString('ip');
    double countQty = 0;
    List<OrderDetailModel> orderList = event.fetchOrder.order.orderDetail;
    OrderDetailModel lineItem = OrderDetailModel();
    Order order = event.fetchOrder.order;
    log('>>>>Is Empty ${orderList.isEmpty}');
    if (orderList.isEmpty) {
      lineItem = await orderDetialController.getOrderDetail(
        ip,
        event.saleID,
        event.orderID,
      );
      // log('LineItem>>>  ${jsonEncode(lineItem.toJson())}');
      orderList.add(lineItem);
      sumItemsTotal(order, event.fetchOrder);
    } else {
      log("Lineitem QTY ${lineItem.printQty}");
      log("lineitem${lineItem}");
      log("LineID >>>>" + jsonEncode(orderList[0].lineId));
      lineItem = orderList.firstWhere(
        (element) => element.lineId == event.saleID,
        orElse: () => null,
      );
      //var get = listOrder[0].lineId;
      if (lineItem == null) {
        lineItem = await orderDetialController.getOrderDetail(
          ip,
          event.saleID,
          event.orderID,
        );
        //log(">>>>>QTY" + jsonEncode(lineItem));
        log(">>>>>>QTY${jsonEncode(lineItem)}");
        orderList.add(lineItem);
        //log(">>>>> orderlist" + jsonEncode(orderList));
        lineItem.total = getItemTotal(lineItem, event.fetchOrder.setting);
        order.grandTotal = sumItemsTotal(order, event.fetchOrder);
      } else {
        if (lineItem.orderDetailId > 0) {
          log("Line item qty++" + jsonEncode(lineItem.qty));
          lineItem.qty++;
        } else {
          log("Line item qty++" + jsonEncode(lineItem.printQty));
          lineItem.printQty++;

          //print("Line item qty++"+jsonEncode(lineItem.printQty));
          lineItem.qty = lineItem.printQty;
        }
        log("Line item qty++" + jsonEncode(lineItem.qty));
        order.grandTotal = sumItemsTotal(order, event.fetchOrder);
      }
    }
    order.grandTotal = sumItemsTotal(order, event.fetchOrder);
    countQty = sumItemQty(orderList);
    StateOrder stateOrder = StateOrder(
      orderDetai: lineItem,
      fetchOrder: event.fetchOrder,
      countQty: countQty,
    );
    emit(stateOrder);
    emit(OrderLoaded(stateOrder: stateOrder));
  }

  void _onUpdateOrder(UpdateOrderEvent event, Emitter<OrderState> emit) async {
    double countQty = 0;
    countQty = sumItemQty(event.fetchOrder.order.orderDetail);
    event.orderDetail.total =
        getItemTotal(event.orderDetail, event.fetchOrder.setting);
    event.fetchOrder.order.grandTotal =
        sumItemsTotal(event.fetchOrder.order, event.fetchOrder);
    StateOrder stateOrder = StateOrder(
        orderDetai: event.orderDetail,
        fetchOrder: event.fetchOrder,
        countQty: countQty);
    emit(stateOrder);
    emit(OrderLoaded(stateOrder: stateOrder));
    stateOrder.show();
  }

  double sumItemsTotal(Order order, FetchOrderModel fetchOrder) {
    double subtotal = 0;
    double taxValue = 0;
    TaxGroup taxGroup;
    for (var item in order.orderDetail) {
      subtotal += getItemTotal(item, fetchOrder.setting);
      if (fetchOrder.setting.taxOption > 0) {
        taxValue += item.taxValue;
      }
    }
    order.taxValue = taxValue;
    order.subTotal = subtotal;
    order.discountValue = order.subTotal * order.discountRate / 100;
    order.grandTotal = order.subTotal - order.discountValue;
    if (fetchOrder.setting.taxOption == 3) {
      taxGroup = fetchOrder.taxGroup.firstWhere(
        (element) => element.id == fetchOrder.setting.tax,
      );
      order.taxRate = taxGroup.rate;
      taxValue = (order.subTotal - order.discountValue) * order.taxRate / 100;
      order.taxValue = taxValue;
      order.grandTotal = order.subTotal + order.taxValue;
    }
    print('>>>>> ${order.grandTotal}');
    return order.grandTotal;
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

  static double getItemTotal(OrderDetailModel orderDetail, Setting setting) {
    double lineTotalNoTax = (orderDetail.qty) *
        (orderDetail.unitPrice) *
        (1 - (orderDetail.discountRate) / 100);
    orderDetail.total = lineTotalNoTax;
    print('>>>>>>lineTotalNoTax: ${lineTotalNoTax}');

    switch (setting.taxOption) {
      case 1:
        orderDetail.taxValue = lineTotalNoTax * orderDetail.taxRate / 100;
        orderDetail.total = lineTotalNoTax + orderDetail.taxValue;
        break;
      case 2:
        orderDetail.taxValue =
            lineTotalNoTax * orderDetail.taxRate / (100 + orderDetail.taxRate);
        orderDetail.total = lineTotalNoTax;
        break;
      case 3:
        orderDetail.taxRate = 0;
        orderDetail.taxValue = 0;
        break;
    }
    return orderDetail.total;
  }
}
