part of 'fetchorder_bloc.dart';

abstract class FetchOrderEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetOrderEvent extends FetchOrderEvent {
  final String ip;
  final int orderId;
  final FetchOrderModel fetchOrderModel;
  GetOrderEvent(
      {@required this.orderId,
      @required this.ip,
      @required this.fetchOrderModel});
}

class UpdateOrderEvent extends FetchOrderEvent {
  FetchOrderModel fetchOrderModel;
  OrderDetailModel orderDetailModel;
  UpdateOrderEvent({this.fetchOrderModel, this.orderDetailModel});
}

class AddNewOrederEvent extends FetchOrderEvent {
  final int saleId;
  final int orderId;
  final FetchOrderModel fetchOrderModel;
  AddNewOrederEvent(
      {this.saleId, @required this.orderId, @required this.fetchOrderModel});
}

class AppOrdedEvent extends FetchOrderEvent {
  final int saleId;
  final int orderId;
  final FetchOrderModel fetchOrderModel;

  AppOrdedEvent(
      {this.saleId, @required this.orderId, @required this.fetchOrderModel});
}

class DeleteNewOrderEvent extends FetchOrderEvent {
  DeleteNewOrderEvent(NeworderInitial neworderInitial);
}
