part of 'customer_bloc.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object> get props => [];
}

class CustomerInitial extends CustomerState {}

class CustomerLoadingState extends CustomerState {}

class ShowCustomerState extends CustomerState {
  final List<Customer> listCustomer;

  ShowCustomerState({this.listCustomer});
}

class ShowCustomerOrderState extends CustomerState {
  final FetchOrderModel fetchOrder;
  ShowCustomerOrderState({this.fetchOrder});
  void show() {
    print("show customer in state : ${fetchOrder.order.customer.name}");
  }
}

class ErrorState extends CustomerState {
  final String message;

  ErrorState(this.message);
}
