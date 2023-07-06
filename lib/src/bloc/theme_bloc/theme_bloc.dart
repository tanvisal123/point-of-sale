import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
      : super(ThemeInitial(
      ThemeData(
          fontFamily: 'battambang',
          primarySwatch: MaterialColor(0xFF1B5E20, const {
            50: const Color(0xFFE8F5E9),
            100: const Color(0xFFC8E6C9),
            200: const Color(0xFFA5D6A7),
            300: const Color(0xFF81C784),
            400: const Color(0xFF66BB6A),
            500: const Color(0xFF66BB6A),
            600: const Color(0xFF43A047),
            700: const Color(0xFF388E3C),
            800: const Color(0xFF2E7D32),
            900: const Color(0xFF1B5E20)
          }),
          primaryColor: Colors.green[900],
          brightness: Brightness.light,
          canvasColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.grey[50],
        ))) {
    on<ThemeEvent>((event, emit) async {
      var prefs = await SharedPreferences.getInstance();
      if (event is StartedTheme) {
        String theme = prefs.getString('theme');
        if (theme == 'green') {
          emit(ThemeLoaded(ThemeData(
            fontFamily: 'battambang',
            primarySwatch: MaterialColor(0xFF1B5E20, const {
              50: const Color(0xFFE8F5E9),
              100: const Color(0xFFC8E6C9),
              200: const Color(0xFFA5D6A7),
              300: const Color(0xFF81C784),
              400: const Color(0xFF66BB6A),
              500: const Color(0xFF66BB6A),
              600: const Color(0xFF43A047),
              700: const Color(0xFF388E3C),
              800: const Color(0xFF2E7D32),
              900: const Color(0xFF1B5E20)
            }),
            primaryColor: Colors.green[900],
            brightness: Brightness.light,
            canvasColor: Colors.transparent,
            scaffoldBackgroundColor: Colors.grey[50],
          )));
        } else if (theme == 'teal') {
          emit(ThemeLoaded(ThemeData(
            fontFamily: 'battambang',
            primarySwatch: MaterialColor(0xFF004D40, const {
              50: const Color(0xFFE0F2F1),
              100: const Color(0xFFB2DFDB),
              200: const Color(0xFF80CBC4),
              300: const Color(0xFF4DB6AC),
              400: const Color(0xFF26A69A),
              500: const Color(0xFF009688),
              600: const Color(0xFF00897B),
              700: const Color(0xFF00796B),
              800: const Color(0xFF00695C),
              900: const Color(0xFF004D40)
            }),
            primaryColor: Colors.teal[900],
            brightness: Brightness.light,
            canvasColor: Colors.transparent,
            scaffoldBackgroundColor: Colors.grey[50],
          )));
        }else if (theme == 'teal') {
          emit(ThemeLoaded(ThemeData(
            fontFamily: 'battambang',
            primarySwatch: MaterialColor(0xFF004D40, const {
              50: const Color(0xFFE0F2F1),
              100: const Color(0xFFB2DFDB),
              200: const Color(0xFF80CBC4),
              300: const Color(0xFF4DB6AC),
              400: const Color(0xFF26A69A),
              500: const Color(0xFF009688),
              600: const Color(0xFF00897B),
              700: const Color(0xFF00796B),
              800: const Color(0xFF00695C),
              900: const Color(0xFF004D40)
            }),
            primaryColor: Colors.teal[900],
            brightness: Brightness.light,
            canvasColor: Colors.transparent,
            scaffoldBackgroundColor: Colors.grey[50],
          )));
        } else if (theme == 'blue') {
          emit(ThemeLoaded(ThemeData(
            fontFamily: 'battambang',
            primarySwatch: MaterialColor(0xFF0D47A1, const {
              50: const Color(0xFFE3F2FD),
              100: const Color(0xFFBBDEFB),
              200: const Color(0xFF90CAF9),
              300: const Color(0xFF64B5F6),
              400: const Color(0xFF42A5F5),
              500: const Color(0xFF2196F3),
              600: const Color(0xFF1E88E5),
              700: const Color(0xFF1976D2),
              800: const Color(0xFF1565C0),
              900: const Color(0xFF0D47A1)
            }),
            primaryColor: Colors.blue[900],
            brightness: Brightness.light,
            canvasColor: Colors.transparent,
            scaffoldBackgroundColor: Colors.grey[50],
          )));
        } else if (theme == 'red') {
          emit(ThemeLoaded(ThemeData(
            fontFamily: 'battambang',
            primarySwatch: MaterialColor(0xFFB71C1C, const {
              50: const Color(0xFFFFEBEE),
              100: const Color(0xFFFFCDD2),
              200: const Color(0xFFEF9A9A),
              300: const Color(0xFFE57373),
              400: const Color(0xFFEF5350),
              500: const Color(0xFFF44336),
              600: const Color(0xFFE53935),
              700: const Color(0xFFD32F2F),
              800: const Color(0xFFC62828),
              900: const Color(0xFFB71C1C),
            }),
            primaryColor: Colors.red[900],
            brightness: Brightness.light,
            canvasColor: Colors.transparent,
            scaffoldBackgroundColor: Colors.grey[50],
          )));
        } else if (theme == 'black') {
          emit(ThemeLoaded(ThemeData(
            fontFamily: 'battambang',
            primarySwatch: MaterialColor(0xFF000000, const {
              50: const Color(0xFF000000),
              100: const Color(0xFF000000),
              200: const Color(0xFF000000),
              300: const Color(0xFF000000),
              400: const Color(0xFF000000),
              500: const Color(0xFF000000),
              600: const Color(0xFF000000),
              700: const Color(0xFF000000),
              800: const Color(0xFF000000),
              900: const Color(0xFF000000),
            }),
            primaryColor: Colors.black,
            brightness: Brightness.light,
            canvasColor: Colors.transparent,
            scaffoldBackgroundColor: Colors.grey[50],
          )));

        }
        else if (theme == 'orange') {
          emit(ThemeLoaded(ThemeData(
            fontFamily: 'battambang',
            primarySwatch: MaterialColor(0xFF004D40, const {
              50: const Color(0xFFE0F2F1),
              100: const Color(0xFFB2DFDB),
              200: const Color(0xFF80CBC4),
              300: const Color(0xFF4DB6AC),
              400: const Color(0xFF26A69A),
              500: const Color(0xFF009688),
              600: const Color(0xFF00897B),
              700: const Color(0xFF00796B),
              800: const Color(0xFF00695C),
              900: const Color(0xFF004D40)
            }),
            primaryColor: Colors.yellow[900],
            brightness: Brightness.light,
            canvasColor: Colors.transparent,
            scaffoldBackgroundColor: Colors.yellow[50],
          )));
        }
      }
      if (event is GreenTheme) {
        prefs.setString('theme', 'green');
        emit(ThemeLoaded(ThemeData(
          fontFamily: 'battambang',
          primarySwatch: MaterialColor(0xFF1B5E20, const {
            50: const Color(0xFFE8F5E9),
            100: const Color(0xFFC8E6C9),
            200: const Color(0xFFA5D6A7),
            300: const Color(0xFF81C784),
            400: const Color(0xFF66BB6A),
            500: const Color(0xFF66BB6A),
            600: const Color(0xFF43A047),
            700: const Color(0xFF388E3C),
            800: const Color(0xFF2E7D32),
            900: const Color(0xFF1B5E20)
          }),
          primaryColor: Colors.green[900],
          brightness: Brightness.light,
          canvasColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.grey[50],
        )));
      }
      if (event is LightTheme) {
        prefs.setString('theme', 'light');
        emit(ThemeLoaded(ThemeData(
          fontFamily: 'battambang',
          primarySwatch: MaterialColor(0xFF004D40, const {
            50: const Color(0xFFE0F2F1),
            100: const Color(0xFFB2DFDB),
            200: const Color(0xFF80CBC4),
            300: const Color(0xFF4DB6AC),
            400: const Color(0xFF26A69A),
            500: const Color(0xFF009688),
            600: const Color(0xFF00897B),
            700: const Color(0xFF00796B),
            800: const Color(0xFF00695C),
            900: const Color(0xFF004D40)
          }),
          primaryColor: Colors.teal[900],
          brightness: Brightness.light,
          canvasColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.grey[50],
        )));
      }
      if (event is TealTheme) {
        prefs.setString('theme', 'teal');
        emit(ThemeLoaded(ThemeData(
          fontFamily: 'battambang',
          primarySwatch: MaterialColor(0xFF004D40, const {
            50: const Color(0xFFE0F2F1),
            100: const Color(0xFFB2DFDB),
            200: const Color(0xFF80CBC4),
            300: const Color(0xFF4DB6AC),
            400: const Color(0xFF26A69A),
            500: const Color(0xFF009688),
            600: const Color(0xFF00897B),
            700: const Color(0xFF00796B),
            800: const Color(0xFF00695C),
            900: const Color(0xFF004D40)
          }),
          primaryColor: Colors.teal[900],
          brightness: Brightness.light,
          canvasColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.grey[50],
        )));
      }
      if (event is BlueTheme) {
        prefs.setString('theme', 'blue');
        emit(ThemeLoaded(ThemeData(
          fontFamily: 'battambang',
          primarySwatch: MaterialColor(0xFF0D47A1, const {
            50: const Color(0xFFE3F2FD),
            100: const Color(0xFFBBDEFB),
            200: const Color(0xFF90CAF9),
            300: const Color(0xFF64B5F6),
            400: const Color(0xFF42A5F5),
            500: const Color(0xFF2196F3),
            600: const Color(0xFF1E88E5),
            700: const Color(0xFF00796B),
            800: const Color(0xFF1565C0),
            900: const Color(0xFF0D47A1)
          }),
          primaryColor: Colors.blue[900],
          brightness: Brightness.light,
          canvasColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.grey[50],
        )));
      }
      if (event is RedTheme) {
        prefs.setString('theme', 'red');
        emit(
          ThemeLoaded(
            ThemeData(
              fontFamily: 'battambang',
              primarySwatch: MaterialColor(0xFFB71C1C, const {
                50: const Color(0xFFFFEBEE),
                100: const Color(0xFFFFCDD2),
                200: const Color(0xFFEF9A9A),
                300: const Color(0xFFE57373),
                400: const Color(0xFFEF5350),
                500: const Color(0xFFF44336),
                600: const Color(0xFFE53935),
                700: const Color(0xFFD32F2F),
                800: const Color(0xFFC62828),
                900: const Color(0xFFB71C1C),
              }),
              primaryColor: Colors.red[900],
              brightness: Brightness.light,
              canvasColor: Colors.transparent,
              scaffoldBackgroundColor: Colors.grey[50],
            ),
          ),
        );
      }

      if (event is BlackTheme) {
        prefs.setString('theme', 'black');
        emit(ThemeLoaded(ThemeData(
          fontFamily: 'battambang',
          primarySwatch: MaterialColor(0xFF000000, const {
            50: const Color(0xFF000000),
            100: const Color(0xFF000000),
            200: const Color(0xFF000000),
            300: const Color(0xFF000000),
            400: const Color(0xFF000000),
            500: const Color(0xFF000000),
            600: const Color(0xFF000000),
            700: const Color(0xFF000000),
            800: const Color(0xFF000000),
            900: const Color(0xFF000000),
          }),
          primaryColor: Colors.black,
          brightness: Brightness.light,
          canvasColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.grey[50],
        )));
      }
      if (event is OrangeTheme) {
        prefs.setString('theme', 'orange');
        emit(ThemeLoaded(ThemeData(
          fontFamily: 'battambang',
          primarySwatch: MaterialColor(0xFF1B5E20, const {
            50: const Color(0xFFFA7D09),
            100: const Color(0xFFA57F5C),
            200: const Color(0xFFA5D6A7),
            300: const Color(0xFF81C784),
            400: const Color(0xFF66BB6A),
            500: const Color(0xFF66BB6A),
            600: const Color(0xFF43A047),
            700: const Color(0xFF388E3C),
            800: const Color(0xFF2E7D32),
            900: const Color(0xFFA57F5C)
          }),
          primaryColor: Colors.yellow[900],
          brightness: Brightness.light,
          canvasColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.yellow[50],
        )));
      }

    });
  }
}
