part of 'displaycurr_bloc.dart';

abstract class DisplaycurrState extends Equatable {
  const DisplaycurrState();

  @override
  List<Object> get props => [];
}

class DisplaycurrInitial extends DisplaycurrState {}

class DisplaycurrLoading extends DisplaycurrState {}

class DisplaycurrLoaded extends DisplaycurrState {
  final List<DisplayCurrModel> displayCurrLs;

  DisplaycurrLoaded({@required this.displayCurrLs});
}

class DisplaycurrError extends DisplaycurrState {
  final String error;

  DisplaycurrError({this.error});
}
