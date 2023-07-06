part of 'table_bloc.dart';

abstract class TableEvent {}

class GetTableEvent extends TableEvent {
  final GroupTable groupTableModel;

  GetTableEvent({
    @required this.groupTableModel,
  });
}
