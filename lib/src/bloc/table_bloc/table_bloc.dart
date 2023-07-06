import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:point_of_sale/src/controllers/service_table_controller.dart';
import 'package:point_of_sale/src/models/service_table_modal.dart';
import 'package:point_of_sale/src/models/table_modal.dart';
part 'table_event.dart';
part 'table_state.dart';

class TableBloc extends Bloc<TableEvent, TableState> {
  TableBloc({
    this.ip,
  }) : super(TableInitial()) {
    on<TableEvent>((event, emit) async {
      if (event is GetTableEvent) {
        emit(TableLoading());
        try {
          List<TableModel> _list =
              await TableController.getTable(event.groupTableModel.id, ip);
          if (_list == null) {
            emit(TableError(message: 'Something went wrong'));
            print('Table is Null');
            return;
          }
          emit(TableLoaded(listTable: _list));
        } catch (e) {
          emit(TableError(message: e.toString()));
        }
      }
    });
  }
  final String ip;
}
