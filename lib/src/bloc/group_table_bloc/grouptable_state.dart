part of 'grouptable_bloc.dart';

abstract class GrouptableState {}

class GrouptableInitial extends GrouptableState {}

class GrouptableLoading extends GrouptableState {}

class GrouptableLoaded extends GrouptableState {
  final ServiceTableModel serviceTable;

  GrouptableLoaded({@required this.serviceTable});
}

class GrouptableError extends GrouptableState {
  final String message;

  GrouptableError({@required this.message});
}
