part of 'tax_bloc.dart';

abstract class TaxEvent extends Equatable {
  const TaxEvent();

  @override
  List<Object> get props => [];
}

class GetTaxEvent extends TaxEvent {}
