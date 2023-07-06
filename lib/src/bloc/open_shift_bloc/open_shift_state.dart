part of 'open_shift_bloc.dart';

abstract class OpenShiftState extends Equatable {
  const OpenShiftState();

  @override
  List<Object> get props => [];
}

class OpenShiftInitial extends OpenShiftState {}

class OpenShiftLoading extends OpenShiftState {}

class OpenShiftLoaded extends OpenShiftState {
  final List<OpenShiftModel> openShiftList;

  OpenShiftLoaded({@required this.openShiftList});
}

class OpenShiftError extends OpenShiftState {
  final String error;

  OpenShiftError({@required this.error});
}
