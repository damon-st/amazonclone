import 'package:amazonclone/common/widgets/bottom_bar.dart';
import 'package:amazonclone/constants/global_variables.dart';
import 'package:amazonclone/features/admin/screens/admin_screens.dart';
import 'package:amazonclone/features/auth/screens/auth_screen.dart';
import 'package:amazonclone/features/auth/services/auth_service.dart';
import 'package:amazonclone/features/home/screens/home_screen.dart';
import 'package:amazonclone/providers/user_provider.dart';
import 'package:amazonclone/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (c) => UserProvider())],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Amazon',
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: GlobalVariables.secondaryColor,
          ),
          scaffoldBackgroundColor: GlobalVariables.backgroundColor,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
          ),
        ),
        onGenerateRoute: (settings) => generateRoute(settings),
        home: Provider.of<UserProvider>(context).user.token.isNotEmpty
            ? Provider.of<UserProvider>(context).user.type == "user"
                ? const BottomBar()
                : const AdminScreen()
            : const AuthScreen());
  }
}
