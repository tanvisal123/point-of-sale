part of 'item_group_bloc.dart';

abstract class ItemGroupEvent {
  const ItemGroupEvent();
  List<Object> get props => [];
}

class GetItemGroup extends ItemGroupEvent {
  final int g1;
  final int g2;
  final int g3;
  final int pId;
  final int level;

  GetItemGroup(
      {@required this.g1,
      @required this.g2,
      @required this.g3,
      @required this.pId,
      @required this.level});
}
