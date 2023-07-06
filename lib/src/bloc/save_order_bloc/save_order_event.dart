part of 'save_order_bloc.dart';

abstract class SaveOrderBlocEvent extends Equatable {
  const SaveOrderBlocEvent();

  @override
  List<Object> get props => [];
}

class GetSaveOrderEvent extends SaveOrderBlocEvent {
  final String ip;
  final int orderId;
  final FetchOrderModel fetchOrderModel;
  GetSaveOrderEvent(
      {this.fetchOrderModel, @required this.orderId, @required this.ip});
}

class DeteleSaveOrder extends SaveOrderBlocEvent {
  final int orderId;
  final String ip;
  DeteleSaveOrder({@required this.orderId, @required this.ip});
}
