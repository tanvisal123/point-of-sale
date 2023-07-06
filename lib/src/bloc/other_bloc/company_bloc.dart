import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_of_sale/src/controllers/company_controller.dart';
import 'dart:async';
import 'package:point_of_sale/src/models/compay_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CompanyEvent extends Equatable {
  const CompanyEvent();
}

class GetCompanyList extends CompanyEvent {
  @override
  List<Object> get props => null;
}
//---------end event---------

abstract class CompanyState extends Equatable {
  const CompanyState();
}

class CompanyInitial extends CompanyState {
  const CompanyInitial();
  @override
  List<Object> get props => [];
}

class CompanyLoading extends CompanyState {
  const CompanyLoading();
  @override
  List<Object> get props => null;
}

class CompanyLoaded extends CompanyState {
  final List<CompanyModel> company;
  const CompanyLoaded({this.company});
  @override
  List<Object> get props => [company];
}

class CompanyError extends CompanyState {
  final String message;
  const CompanyError(this.message);
  @override
  List<Object> get props => [message];
}
//----------end state-------------

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  CompanyBloc(CompanyState initialState) : super(initialState) {
    on<CompanyEvent>((event, emit) async {
      if (event is GetCompanyList) {
        try {
          var _sp = await SharedPreferences.getInstance();
          var _ip = _sp.getString('ip');
          emit(CompanyLoading());
          final comList = await CompanyController.eachCompany(_ip);
          emit(CompanyLoaded(company: comList));
          if (comList.isEmpty) {
            emit(CompanyError("Company is empty !"));
          }
        } catch (_) {
          emit(CompanyError("Failed to fetch data.Is your device online?"));
        }
      }
    });
  }

  CompanyState get initialState => CompanyInitial();

  // @override
  // Stream<CompanyState> mapEventToState(CompanyEvent event) async* {
  //   if (event is GetCompanyList) {
  //     try {
  //       var _sp = await SharedPreferences.getInstance();
  //       var _ip = _sp.getString('ip');
  //       yield CompanyLoading();
  //       final comList = await CompanyController.eachCompany(_ip);
  //       yield CompanyLoaded(company: comList);
  //       if (comList.isEmpty) {
  //         yield CompanyError("Company is empty !");
  //       }
  //     } catch (_) {
  //       yield CompanyError("Failed to fetch data.Is your device online?");
  //     }
  //   }
  // }
}
