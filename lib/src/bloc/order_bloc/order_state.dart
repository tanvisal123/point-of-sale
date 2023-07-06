part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final StateOrder stateOrder;

  OrderLoaded({this.stateOrder});
}

class StateOrder extends OrderState {
  final FetchOrderModel fetchOrder;
  final OrderDetailModel orderDetai;
  final double countQty;
  StateOrder({this.fetchOrder, this.orderDetai, this.countQty});
  void show() {
    print("show item name : ${orderDetai.khmerName}");
    print("show qty : ${orderDetai.qty}");
    print("show count qty : $countQty");
  }
}

class OrderError {
  final String message;
  OrderError(this.message);
}
