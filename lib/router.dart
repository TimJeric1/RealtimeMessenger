import 'dart:io';

import 'package:flutter/material.dart';

import 'common/widgets/error.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/otp_screen.dart';
import 'features/auth/screens/user_information_screen.dart';
import 'features/chat/screens/chat_screen.dart';
import 'features/contacts/screens/contacts_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  return MaterialPageRoute(
    builder: (context) => _routeBuilder(context, settings),
  );
}

Widget _routeBuilder(BuildContext context, RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return const LoginScreen();
    case OTPScreen.routeName:
      return _buildOTPScreen(settings);
    case UserInformationScreen.routeName:
      return const UserInformationScreen();
    case ContactsScreen.routeName:
      return const ContactsScreen();
    case ChatScreen.routeName:
      return _buildChatScreen(settings);
    default:
      return _buildDefaultScreen();
  }
}

Widget _buildOTPScreen(RouteSettings settings) {
  final verificationId = settings.arguments as String;
  return OTPScreen(
    verificationId: verificationId,
  );
}

Widget _buildChatScreen(RouteSettings settings) {
  final arguments = settings.arguments as Map<String, dynamic>;
  final name = arguments['name'];
  final uid = arguments['uid'];
  final profilePic = arguments['profilePic'];
  return ChatScreen(
    name: name,
    uid: uid,
    profilePic: profilePic,
  );
}

Widget _buildDefaultScreen() {
  return const Scaffold(
    body: ErrorScreen(error: 'This page doesn\'t exist'),
  );
}
