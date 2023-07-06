part of 'open_shift_bloc.dart';

abstract class OpenShiftEvent extends Equatable {
  const OpenShiftEvent();

  @override
  List<Object> get props => [];
}

class GetOpenShiftEvent extends OpenShiftEvent {}
