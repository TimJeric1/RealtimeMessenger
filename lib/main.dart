import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtime_messenger/router.dart';

import 'common/models/user_model.dart';
import 'common/utils/colors.dart';
import 'common/widgets/error.dart';
import 'common/widgets/loading_widget.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/landing/screens/landing_screen.dart';
import 'common/firebase/firebase_options.dart';
import 'main_screen.dart';

void main() async {
  await _initializeFirebase();
  runApp(const AppProviderScope());
}

Future<void> _initializeFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name: "realtime_messenger",
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    Firebase.app();
  }
}

class AppProviderScope extends StatelessWidget {
  const AppProviderScope({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: MyApp(),
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'realtime_messenger',
      theme: _theme(),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: _home(ref),
      builder: EasyLoading.init(),
    );
  }

  ThemeData _theme() {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        color: appBarColor,
      ),
    );
  }

  Widget _home(WidgetRef ref) {
    return ref.watch(userDataAuthProvider).when(
      data: _handleUserData,
      error: _handleError,
      loading: () => const LoadingWidget(),
    );
  }

  Widget _handleUserData(UserModel? user) {
    debugPrint('user: ${user?.name ?? 'null'}');
    if (user == null) {
      return const LandingScreen();
    }
    return const MainScreen();
  }

  Widget _handleError(Object err, StackTrace? trace) {
    return ErrorScreen(
      error: err.toString(),
    );
  }
}
