import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:point_of_sale/src/controllers/service_table_controller.dart';
import 'package:point_of_sale/src/models/service_table_modal.dart';
import 'dart:developer' as dev;
part 'grouptable_event.dart';
part 'grouptable_state.dart';

class GrouptableBloc extends Bloc<GrouptableEvent, GrouptableState> {
  final String ip;
  GrouptableBloc({@required this.ip}) : super(GrouptableInitial()) {
    on<GrouptableEvent>((event, emit) async {
      ServiceTableModel serviceTableModel =
          await ServiceTableController.getGroupTable(ip);
      dev.log(serviceTableModel.toJson().toString());
      return emit(GrouptableLoaded(serviceTable: serviceTableModel));
    });
  }
}
