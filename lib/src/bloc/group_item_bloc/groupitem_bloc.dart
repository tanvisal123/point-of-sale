import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:point_of_sale/src/controllers/gorup1_controller.dart';
import 'package:point_of_sale/src/controllers/group2_controller.dart';
import 'package:point_of_sale/src/controllers/group3_controller.dart';
import 'package:point_of_sale/src/models/gorupItem_modal.dart';
part 'groupitem_event.dart';
part 'groupitem_state.dart';

class GroupitemBloc extends Bloc<GroupitemEvent, GroupitemState> {
  GroupitemBloc({@required this.ip}) : super(GroupitemInitial()) {
    on<GroupitemEvent>((event, emit) async {
      if (event is GetGroupItemEvent) {
        emit(GroupItemLoading());
        List<GroupItemModel> _list = [];
        try {
          if (event.type == "G1") {
            _list = await Group1Controller.eachGroup1(ip);
          } else if (event.type == "G2") {
            _list = await Group2Controller.eachGroup2(event.g1Id, ip);
          } else if (event.type == "G3") {
            _list =
                await Group3Controller.eachGroup3(event.g1Id, event.g2Id, ip);
          }
          emit(GroupItemLoaded(groupItemList: _list));
        } catch (e) {
          emit(GroupItemError(message: e.toString()));
        }
      }
    });
  }

  final String ip;

  @override
  Stream<GroupitemState> mapEventToState(GroupitemEvent event) async* {}
}
