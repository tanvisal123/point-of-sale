part of 'groupitem_bloc.dart';

abstract class GroupitemState {}

class GroupitemInitial extends GroupitemState {}

class GroupItemLoading extends GroupitemState {}

class GroupItemLoaded extends GroupitemState {
  final List<GroupItemModel> groupItemList;

  GroupItemLoaded({@required this.groupItemList});
}

class GroupItemError extends GroupitemState {
  final String message;

  GroupItemError({@required this.message});
}
