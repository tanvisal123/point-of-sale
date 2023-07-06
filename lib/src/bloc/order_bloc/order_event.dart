part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class AddOrderEvent extends OrderEvent {
  final int saleID;
  final int orderID;
  final FetchOrderModel fetchOrder;
  final bool isAddOn;
  AddOrderEvent({
    this.saleID,
    this.orderID,
    this.fetchOrder,
    this.isAddOn = false,
  });
}

class UpdateOrderEvent extends OrderEvent {
  final OrderDetailModel orderDetail;
  final FetchOrderModel fetchOrder;

  UpdateOrderEvent({this.orderDetail, this.fetchOrder});
}

class DeleteOrderEvent extends OrderEvent {}
