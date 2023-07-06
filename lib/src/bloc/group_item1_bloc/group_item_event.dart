part of 'group_item_bloc.dart';

abstract class GroupItemEvent extends Equatable {
  const GroupItemEvent();

  @override
  List<Object> get props => [];
}

class GetGroupItem extends GroupItemEvent {
  final int tableId;
  final int orderId;
  final int customerId;
  final bool defualtValue;
  GetGroupItem(
      {@required this.tableId,
      @required this.orderId,
      @required this.customerId,
      @required this.defualtValue});
}
