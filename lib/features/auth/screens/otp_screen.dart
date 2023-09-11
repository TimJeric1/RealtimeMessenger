import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/colors.dart';
import '../controller/auth_controller.dart';

class OTPScreen extends ConsumerWidget {
  static const String routeName = '/otp-screen';
  final String verificationId;

  const OTPScreen({
    Key? key,
    required this.verificationId,
  }) : super(key: key);

  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP) {
    ref.read(authControllerProvider).verifyOTP(
      context,
      verificationId,
      userOTP,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _instructionsText(),
            _otpField(ref, context, size),
            _spacer(),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        'Verifying your number',
        style: TextStyle(color: textColor),
      ),
      elevation: 0,
      backgroundColor: backgroundColor,
    );
  }



  Widget _instructionsText() {
    return const Text('We have sent an SMS with a code.');
  }

  Widget _otpField(WidgetRef ref, BuildContext context, Size size) {
    return SizedBox(
      width: size.width * 0.5,
      child: TextField(
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          hintText: '- - - - - -',
          hintStyle: TextStyle(
            fontSize: 30,
          ),
        ),
        keyboardType: TextInputType.number,
        onChanged: (val) {
          if (val.length == 6) {
            verifyOTP(ref, context, val.trim());
          }
        },
      ),
    );
  }

  Widget _spacer() {
    return const SizedBox(height: 250);
  }
}
