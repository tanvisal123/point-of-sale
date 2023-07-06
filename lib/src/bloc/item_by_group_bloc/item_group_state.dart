part of 'item_group_bloc.dart';

abstract class ItemGroupState extends Equatable {
  const ItemGroupState();
  @override
  List<Object> get props => [];
}

class ItemGroupInitial extends ItemGroupState {}

class ItemGroupLoading extends ItemGroupState {}

class ItemGroupLoaded extends ItemGroupState {
  final List<SaleItems> listItem;
  ItemGroupLoaded({@required this.listItem});
}

class ItemGroupError extends ItemGroupState {
  final String message;

  ItemGroupError({@required this.message});
}
