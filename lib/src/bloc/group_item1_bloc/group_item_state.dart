part of 'group_item_bloc.dart';

abstract class GroupItemState extends Equatable {
  const GroupItemState();
  @override
  List<Object> get props => [];
}

class GroupItemInitial extends GroupItemState {}

class GroupItemLoading extends GroupItemState {}

class GroupItemLoaded extends GroupItemState {
  final FetchOrderModel fetchOrderModel;
  GroupItemLoaded(this.fetchOrderModel);
}

class GroupItemError extends GroupItemState {
  final String message;

  GroupItemError(this.message);
}
