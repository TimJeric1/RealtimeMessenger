import 'package:flutter/material.dart';

import '../../../common/utils/colors.dart';
import '../../../common/widgets/custom_button.dart';
import '../../auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _welcomeText(),
            _image(),
            _continueButton(size, context),
          ],
        ),
      ),
    );
  }



  Widget _welcomeText() {
    return const Text(
      'Welcome to Realtime Messenger',
      style: TextStyle(
        fontSize: 33,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _image() {
    return Image.asset(
      'assets/bg.png',
      height: 340,
      width: 340,
      color: buttonColor,
    );
  }

  Widget _continueButton(Size size, BuildContext context) {
    return SizedBox(
      width: size.width * 0.75,
      child: CustomButton(
        label: 'CONTINUE',
        action: () => navigateToLoginScreen(context),
      ),
    );
  }
}
