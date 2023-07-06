part of 'language_bloc.dart';

abstract class LanguageState {
  final Locale locale;

  LanguageState(this.locale);
}

class LanguageInitial extends LanguageState {
  LanguageInitial(Locale locale) : super(locale);
}

class LanguageSuccess extends LanguageState {
  LanguageSuccess(Locale locale) : super(locale);
}
