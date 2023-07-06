part of 'save_order_bloc.dart';

abstract class SaveOrderBlocState extends Equatable {
  const SaveOrderBlocState();

  @override
  List<Object> get props => [];
}

class SaveOrderBlocInitial extends SaveOrderBlocState {}

class SaveOrderLoading extends SaveOrderBlocState {}

class SaveOrderLoaded extends SaveOrderBlocState {
  final List<Order> orders;
  SaveOrderLoaded({@required this.orders});
}

class SaveOrderError extends SaveOrderBlocState {
  final String message;
  SaveOrderError({this.message});
}
