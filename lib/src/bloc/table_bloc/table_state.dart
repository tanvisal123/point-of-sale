part of 'table_bloc.dart';

abstract class TableState {}

class TableInitial extends TableState {}

class TableLoading extends TableState {}

class TableLoaded extends TableState {
  final List<TableModel> listTable;

  TableLoaded({@required this.listTable});
}

class TableError extends TableState {
  final String message;

  TableError({@required this.message});
}
