import 'dart:ui';

import 'package:bloc/bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dev;
part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageInitial(Locale('en', 'US'))) {
    on<StartedLanguage>((event, emit) async {
      if (event is StartedLanguage) {
        var prefs = await SharedPreferences.getInstance();
        String _languageCode = prefs.getString('langCode') ?? 'en';
        String _countryCode = prefs.getString('conCode') ?? 'US';
        dev.log("A:$_languageCode B:$_countryCode");
        dev.log('');
        emit(LanguageSuccess(Locale(_languageCode, _countryCode)));
      }
    });
    on<LoadLanguage>((event, emit) async {
      if (event is LoadLanguage) {
        var prefs = await SharedPreferences.getInstance();
        prefs.setString('langCode', event.locale.languageCode);
        prefs.setString('conCode', event.locale.countryCode);
        String _languageCode = prefs.getString('langCode') ?? 'en';
        String _countryCode = prefs.getString('conCode') ?? 'US';
        dev.log("OnLoaded{A:$_languageCode B:$_countryCode}");
        emit(LanguageSuccess(Locale(_languageCode, _countryCode)));
      }
    });
  }

  // @override
  // Stream<LanguageState> mapEventToState(LanguageEvent event) async* {
  //   if (event is StartedLanguage) {
  //     var prefs = await SharedPreferences.getInstance();
  //     String _languageCode = prefs.getString('langCode') ?? 'en';
  //     String _countryCode = prefs.getString('conCode') ?? 'US';
  //     yield LanguageSuccess(Locale(_languageCode, _countryCode));
  //   }
  //   if (event is LoadLanguage) {
  //     var prefs = await SharedPreferences.getInstance();
  //     prefs.setString('langCode', event.locale.languageCode);
  //     prefs.setString('conCode', event.locale.countryCode);
  //     String _languageCode = prefs.getString('langCode') ?? 'en';
  //     String _countryCode = prefs.getString('conCode') ?? 'US';
  //     yield LanguageSuccess(Locale(_languageCode, _countryCode));
  //   }
  // }
}
