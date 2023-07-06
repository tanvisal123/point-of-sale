import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_of_sale/src/controllers/branch_controller.dart';
import 'dart:async';
import 'package:point_of_sale/src/models/branch_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BranchEvent extends Equatable {
  const BranchEvent();
}

class GetBranchList extends BranchEvent {
  @override
  List<Object> get props => null;
}

//---------end event--------

abstract class BranchState extends Equatable {
  const BranchState();
}

class BranchInitial extends BranchState {
  const BranchInitial();
  @override
  List<Object> get props => [];
}

class BranchLoading extends BranchState {
  const BranchLoading();
  @override
  List<Object> get props => null;
}

class BranchLoaded extends BranchState {
  final List<Branch> branch;
  const BranchLoaded({this.branch});
  @override
  List<Object> get props => [branch];
}

class BranchError extends BranchState {
  final String message;
  const BranchError(this.message);
  @override
  List<Object> get props => [message];
}

//--------end state--------

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  BranchBloc(BranchState initialState) : super(initialState) {
    on<BranchEvent>((event, emit) async {
      if (event is GetBranchList) {
        try {
          var _sp = await SharedPreferences.getInstance();
          var _ip = _sp.getString('ip');
          emit(BranchLoading());
          final branchList = await BranchController.eachBranch(_ip);
          emit(BranchLoaded(branch: branchList));
          if (branchList.isEmpty) {
            emit(BranchError("Branch is empty !"));
          }
        } catch (e) {
          emit(BranchError("Failed to fetch data. is your device online?"));
        }
      }
    });
  }

  BranchState get initState => BranchInitial();

  // @override
  // Stream<BranchState> mapEventToState(BranchEvent event) async* {
  //   if (event is GetBranchList) {
  //     try {
  //       var _sp = await SharedPreferences.getInstance();
  //       var _ip = _sp.getString('ip');
  //       yield BranchLoading();
  //       final branchList = await BranchController.eachBranch(_ip);
  //       yield BranchLoaded(branch: branchList);
  //       if (branchList.isEmpty) {
  //         yield BranchError("Branch is empty !");
  //       }
  //     } catch (e) {
  //       yield BranchError("Failed to fetch data. is your device online?");
  //     }
  //   }
  // }
}
