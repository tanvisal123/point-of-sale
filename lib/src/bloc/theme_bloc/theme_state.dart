part of 'theme_bloc.dart';

abstract class ThemeState {
  final ThemeData themeData;

  ThemeState(this.themeData);
}

class ThemeInitial extends ThemeState {
  ThemeInitial(ThemeData themeData) : super(themeData);
}

class ThemeLoaded extends ThemeState {
  ThemeLoaded(ThemeData themeData) : super(themeData);
}
