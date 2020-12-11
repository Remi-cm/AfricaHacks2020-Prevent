import 'package:Prevent/providers/guestStatusProvider.dart';
import 'package:Prevent/providers/needProvider.dart';
import 'package:Prevent/providers/productProvider.dart';
import 'package:Prevent/providers/userBudgetProvider.dart';
import 'package:Prevent/routes.dart';
import 'package:Prevent/theming/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/userProfileProvider.dart';
import 'providers/themeProvider.dart';

final GlobalKey<NavigatorState> _navigatorKey = new GlobalKey<NavigatorState>();
final ThemeData _lightMode = buildLightMode();
final ThemeData _darkMode = buildDarkMode();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  //final _notifier = ValueNotifier<ThemeModel>(ThemeModel(ThemeMode.light));
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeModel>(
        create: (_) => ThemeModel(),
        child: MultiProvider(
            providers: [
              ChangeNotifierProvider<GuestStatusProvider>(create: (_) => GuestStatusProvider(false),),
              ChangeNotifierProvider<UserBudgetProvider>(create: (_) => UserBudgetProvider(0),),
              ChangeNotifierProvider<NeedProvider>(create: (_) => NeedProvider(
                false, 1, 1, 2, 1, false, false
              ),),
              ChangeNotifierProvider<UserProfileProvider>(create: (_) => UserProfileProvider(
                null, null, null, null, null, null, null, null, null, null, null
              ),),
              ChangeNotifierProvider<ProductProvider>(create: (_) => ProductProvider(
                null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
              ),),
            ],
          child: Consumer<ThemeModel>(builder: (_, model, __) {
            final mode = model.mode;
            return MaterialApp(
              title: 'Flutter Demo',
              theme: _lightMode,
              darkTheme: _darkMode,
              themeMode: mode,
              navigatorKey: _navigatorKey,
              onGenerateRoute: Routes.generateRoute,
            );
          }),
        ));
  }
}
