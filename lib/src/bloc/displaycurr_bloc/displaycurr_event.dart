part of 'displaycurr_bloc.dart';

abstract class DisplaycurrEvent extends Equatable {
  const DisplaycurrEvent();

  @override
  List<Object> get props => [];
}

class GetDisplayCurrEvent extends DisplaycurrEvent {}
