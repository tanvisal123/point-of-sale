part of 'fetchorder_bloc.dart';

abstract class FetchOrderState extends Equatable {
  const FetchOrderState();

  @override
  List<Object> get props => [];
}

class NeworderInitial extends FetchOrderState {}

class NeworderLoading extends FetchOrderState {}

class NeworderLoaded extends FetchOrderState {
  final StateNewOrder stateOrder;
  NeworderLoaded({@required this.stateOrder});
}

class NeworderError extends FetchOrderState {
  final String message;

  NeworderError({this.message});
}

class StateNewOrder extends FetchOrderState {
  final double coutQty;
  final double subTotal;
  final double grandTotal;
  double printQty;
  final FetchOrderModel fetchOrderModel;
  final OrderDetailModel lineItem;
  StateNewOrder({
    @required this.subTotal,
    @required this.coutQty,
    @required this.grandTotal,
    @required this.lineItem,
    @required this.fetchOrderModel,
    @required this.printQty,
  });
  void show() {
    print("${lineItem.khmerName} (${lineItem.qty})");
  }
}
