import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/src/controllers/groupItem_controller.dart';
import 'package:point_of_sale/src/models/fetch_oreder_model.dart';

part 'item_group_event.dart';
part 'item_group_state.dart';

class ItemGroupBloc extends Bloc<ItemGroupEvent, ItemGroupState> {
  final String ip;
  ItemGroupBloc(this.ip) : super(ItemGroupInitial()) {
    on<GetItemGroup>((event, emit) async {
      emit(ItemGroupLoading());
      try {
        List<SaleItems> _list = await GroupItemController().getGroupItem(
            ip, event.g1, event.g2, event.g3, event.pId, event.level);
        if (_list != null) {
          emit(ItemGroupLoaded(listItem: _list));
        } else {
          print("List is empty");
        }
      } catch (e) {
        emit(ItemGroupError(message: e.toString()));
      }
    });
  }
  @override
  void onEvent(ItemGroupEvent event) {
    super.onEvent(event);
    print(event);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
