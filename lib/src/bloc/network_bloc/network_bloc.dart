import 'dart:async';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc() : super(ConnectionInitial()) {
    on<NetworkEvent>((event, emit) {
      if (event is ListenConnection) {
        _subscription = DataConnectionChecker().onStatusChange.listen((status) {
          add(ConnectionChanged(status == DataConnectionStatus.disconnected
              ? ConnectionFailure()
              : ConnectionSuccess()));
        });
      }
      if (event is ConnectionChanged) emit(event.connection);
    });
  }

  StreamSubscription _subscription;
  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
