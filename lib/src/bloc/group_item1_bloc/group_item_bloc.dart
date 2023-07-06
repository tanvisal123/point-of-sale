import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:point_of_sale/src/controllers/fetchorder_controller.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';

part 'group_item_event.dart';
part 'group_item_state.dart';

class GroupItemBloc extends Bloc<GroupItemEvent, GroupItemState> {
  final String ip;
  GroupItemBloc({@required this.ip}) : super(GroupItemInitial()) {
    on<GetGroupItem>((event, emit) async {
      try {
        emit(GroupItemLoading());
        FetchOrderModel fetchOrderModel = await FetchOrderController()
            .getFetchOrder(ip, event.tableId, event.orderId, event.customerId,
                event.defualtValue);
        emit(GroupItemLoaded(fetchOrderModel));
      } catch (e) {
        emit(GroupItemError(e.toString()));
      }
    });
  }
}
