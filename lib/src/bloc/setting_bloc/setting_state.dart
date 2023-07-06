part of 'setting_bloc.dart';

abstract class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object> get props => [];
}

class SettingInitial extends SettingState {}

class SettingLoading extends SettingState {}

class SettingLoaded extends SettingState {
  final List<SettingModel> settingList;

  SettingLoaded({@required this.settingList});
}

class SettingError extends SettingState {
  final String error;

  SettingError({@required this.error});
}
