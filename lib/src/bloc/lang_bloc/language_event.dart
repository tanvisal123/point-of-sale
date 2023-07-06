part of 'language_bloc.dart';

abstract class LanguageEvent {}

class StartedLanguage extends LanguageEvent {}

class LoadLanguage extends LanguageEvent {
  final Locale locale;
  LoadLanguage(this.locale);
}
