part of 'groupitem_bloc.dart';

abstract class GroupitemEvent {}

class GetGroupItemEvent extends GroupitemEvent {
  final String type;
  final int g1Id;
  final int g2Id;

  GetGroupItemEvent(
      {@required this.type, @required this.g1Id, @required this.g2Id});
}
