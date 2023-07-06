part of 'customer_bloc.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object> get props => [];
}

class GetCustomerEvent extends CustomerEvent {
  final String ip;
  GetCustomerEvent(this.ip);
}

class ChangeCustomerEvent extends CustomerEvent {
  final String ip;
  final int orderId;
  final int tableId;
  final bool defualtOrder;
  final int customerId;
  ChangeCustomerEvent(
      {this.ip,
      this.orderId,
      this.tableId,
      this.defualtOrder,
      this.customerId});
}

class AddCustomerToOrderEvent extends CustomerEvent {
  final String ip;
  final int orderId;
  final int tableId;
  final bool defualtOrder;
  final int customerId;
  final Customer customer;

  AddCustomerToOrderEvent(
      {this.ip,
      this.orderId,
      this.tableId,
      this.defualtOrder,
      this.customer,
      this.customerId});
}

class DeleteCustomerEvent extends CustomerEvent {}
