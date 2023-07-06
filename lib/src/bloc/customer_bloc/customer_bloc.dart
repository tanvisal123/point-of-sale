import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:point_of_sale/src/controllers/customer_controller.dart';
import 'package:point_of_sale/src/controllers/fetchorder_controller.dart';
import 'package:point_of_sale/src/models/customer_model.dart';
import '../../models/fetch_oreder_model.dart';
part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  CustomerBloc() : super(CustomerInitial()) {
    final FetchOrderController fetchOrderController = FetchOrderController();
    on<CustomerEvent>((event, emit) async {
      if (event is GetCustomerEvent) {
        try {
          List<Customer> listCustomer =
              await CustomerController.getCustomer(event.ip);
          emit(ShowCustomerState(listCustomer: listCustomer));
        } catch (e) {
          emit(ErrorState(e));
        }
      } else if (event is AddCustomerToOrderEvent) {
        try {
          FetchOrderModel fetchOrderModel =
              await fetchOrderController.getFetchOrder(
            event.ip,
            event.orderId,
            event.tableId,
            event.customerId,
            event.defualtOrder,
          );
          fetchOrderModel.order.customerId = event.customerId;
          fetchOrderModel.order.customer = event.customer;
          emit(ShowCustomerOrderState(fetchOrder: fetchOrderModel));
        } catch (e) {
          emit(ErrorState(e));
        }
      } else if (event is ChangeCustomerEvent) {
        FetchOrderModel fetchOrderModel =
            await fetchOrderController.getFetchOrder(
          event.ip,
          event.orderId,
          event.tableId,
          event.customerId,
          event.defualtOrder,
        );
        emit(ShowCustomerOrderState(fetchOrder: fetchOrderModel));
      } else if (event is DeleteCustomerEvent) {
        emit(CustomerInitial());
      }
    });
  }
}
