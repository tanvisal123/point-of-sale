import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:path_provider/path_provider.dart';
import 'package:point_of_sale/src/ManageLocalData/constant_ip.dart';
import 'package:point_of_sale/src/bloc/cancel_receipt_bloc/cancel_receipt_bloc.dart';
import 'package:point_of_sale/src/bloc/customer_bloc/customer_bloc.dart';
import 'package:point_of_sale/src/bloc/displaycurr_bloc/displaycurr_bloc.dart';
import 'package:point_of_sale/src/bloc/fetchorder_bloc/fetchorder_bloc.dart';
import 'package:point_of_sale/src/bloc/group_item1_bloc/group_item_bloc.dart';
import 'package:point_of_sale/src/bloc/group_table_bloc/grouptable_bloc.dart';
import 'package:point_of_sale/src/bloc/item_by_group_bloc/item_group_bloc.dart';
import 'package:point_of_sale/src/bloc/open_shift_bloc/open_shift_bloc.dart';
import 'package:point_of_sale/src/bloc/order_bloc/order_bloc.dart';
import 'package:point_of_sale/src/bloc/payment_mean_bloc/paymentmean_bloc.dart';
import 'package:point_of_sale/src/bloc/save_order_bloc/save_order_bloc.dart';
import 'package:point_of_sale/src/bloc/setting_bloc/setting_bloc.dart';
import 'package:point_of_sale/src/bloc/table_bloc/table_bloc.dart';
import 'package:point_of_sale/src/screens/home_screen.dart';
import 'package:point_of_sale/src/screens/login_screen.dart';
import 'package:point_of_sale/src/services/share_prefer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/bloc/lang_bloc/language_bloc.dart';
import 'src/bloc/network_bloc/bloc.dart';
import 'src/bloc/theme_bloc/theme_bloc.dart';
import 'src/helpers/app_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  Bloc.observer = POSBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await getApplicationDocumentsDirectory(); //
  await ipAddress.getIP();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  await SharePrefer().init();
  runApp(Dashboard());
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _ip = '';
  String token;
  bool isExpired = false;
  DateTime expireDate;
  Future<void> _getIPAddress() async {
    var _prefs = await SharedPreferences.getInstance();
     _ip = _prefs.getString('ip');
     _ip = ipAddress.ip;
    token = _prefs.getString('token');
     print('IP MainPage = $_ip');
    print("token = $token");
    isExpired = Jwt.isExpired(token);
    expireDate = Jwt.getExpiryDate(token);
    print("token expire : $isExpired");
  }

  @override
  void initState() {
    super.initState();
    _getIPAddress();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NetworkBloc>(
          create: (context) => NetworkBloc()..add(ListenConnection()),
        ),
        BlocProvider<OrderBloc>(
            create: (context) => OrderBloc(ip: ipAddress.ip)),
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc()..add(StartedTheme()),
        ),
        BlocProvider<LanguageBloc>(
          create: (context) => LanguageBloc()..add(StartedLanguage()),
        ),
        BlocProvider<GrouptableBloc>(
            create: (context) =>
                GrouptableBloc(ip: ipAddress.ip)..add(GroupTableEvent())),
        BlocProvider<TableBloc>(
            create: (context) => TableBloc(ip: ipAddress.ip)),
        BlocProvider<DisplaycurrBloc>(
          create: (context) => DisplaycurrBloc(ip: ipAddress.ip),
        ),
        BlocProvider<PaymentmeanBloc>(
          create: (context) => PaymentmeanBloc(ip: ipAddress.ip),
        ),
        BlocProvider<OpenShiftBloc>(
          create: (context) => OpenShiftBloc(ip: ipAddress.ip),
        ),
        BlocProvider<SettingBloc>(
          create: (context) => SettingBloc(ip: ipAddress.ip),
        ),
        BlocProvider<CancelReceiptBloc>(
          create: (context) => CancelReceiptBloc(ip: ipAddress.ip),
        ),
        BlocProvider<GroupItemBloc>(
            create: ((context) => GroupItemBloc(ip: ipAddress.ip))),
        BlocProvider<ItemGroupBloc>(
          create: ((context) => ItemGroupBloc(ipAddress.ip)),
        ),
        BlocProvider<FetchOrderBloc>(
            create: (context) => FetchOrderBloc(ip: ipAddress.ip)),
        BlocProvider<SaveOrderBlocBloc>(
            create: (context) => SaveOrderBlocBloc()),
        BlocProvider(create: (context) => CustomerBloc())
        // BlocProvider<TaxBloc>(
        //   create: (context) => TaxBloc(ip: ipAddress.ip)..add(GetTaxEvent()),
        // ),
        //====================================================
        // BlocProvider<BranchBloc>(
        //   create: (context) => BranchBloc(BranchInitial()),
        // ),
        // BlocProvider<CompanyBloc>(
        //   create: (context) => CompanyBloc(CompanyInitial()),
        // ),
        // BlocProvider<DisCurrencyBloc>(
        //   create: (context) => DisCurrencyBloc(DisCurrencyInitial()),
        // ),
        // BlocProvider<PriceListBloc>(
        //   create: (context) => PriceListBloc(PriceListInitial()),
        // ),
        // BlocProvider<WarehouseBloc>(
        //   create: (context) => WarehouseBloc(WarehouseInitial()),
        // ),
        //==========================================================
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, languageState) {
              return MaterialApp(
                locale: languageState.locale,
                initialRoute: ipAddress.ip,
                localizationsDelegates: [
                  AppLocalization.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  FallbackCupertinoLocalisationsDelegate(),
                ],
                supportedLocales: [Locale('en', 'US'), Locale('km', 'KH')],
                //home: LoginScreen(ip: _ip),
                home: isExpired == true || token == null
                    ? LoginScreen()
                    : HomeScreen(ip: ipAddress.ip),
                routes: <String, WidgetBuilder>{
                  '/home': (context) => HomeScreen(ip: ipAddress.ip),
                },
                builder: (context, screen) {
                  return BlocBuilder<NetworkBloc, NetworkState>(
                    builder: (context, state) {
                      return Scaffold(
                        //:jsonplaceholdertest(),
                        // :testingapi(ip: ipAddress.ip,),
                        appBar: state is ConnectionSuccess
                            ? null
                            : PreferredSize(
                                preferredSize: Size.fromHeight(25.0),
                                child: _buildAppBar(context),
                              ),
                        body: screen,
                      );
                    },
                  );
                },
                title: 'EDI POS',
                theme: state.themeData,
                debugShowCheckedModeBanner: false,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return BlocBuilder<NetworkBloc, NetworkState>(
      builder: (context, state) {
        return AppBar(
          backgroundColor:
              state is ConnectionSuccess ? Colors.green : Colors.red,
          title: Text(
            state is ConnectionSuccess
                ? AppLocalization.of(context).getTranValue('connected')
                : AppLocalization.of(context).getTranValue('no_internet'),
            style: TextStyle(fontSize: 13, color: Colors.white),
          ),
          centerTitle: true,
        );
      },
    );
  }
}

class POSBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    print(change);
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}
