part of 'tax_bloc.dart';

abstract class TaxState extends Equatable {
  const TaxState();

  @override
  List<Object> get props => [];
}

class TaxInitial extends TaxState {}

class TaxLoading extends TaxState {}

class TaxLoaded extends TaxState {
  final List<TaxModel> taxList;

  TaxLoaded({@required this.taxList});
}

class TaxError extends TaxState {
  final String error;

  TaxError({@required this.error});
}
