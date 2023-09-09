import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/colors.dart';
import '../../../common/utils/utils.dart';
import '../../../common/widgets/custom_button.dart';
import '../controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 150),
              _countryPickerButton(),
              _phoneNumberInput(size),
              const SizedBox(height: 100),
              _nextButton(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        'Enter your phone number',
        style: TextStyle(color: textColor),
      ),
      elevation: 0,
      backgroundColor: backgroundColor,
    );
  }



  TextButton _countryPickerButton() {
    return TextButton(
      onPressed: pickCountry,
      child: const Text('Pick Country', style: TextStyle(color: blueTextColor)),
    );
  }

  Row _phoneNumberInput(Size size) {
    return Row(
      children: [
        if (country != null) Text('+${country!.phoneCode}'),
        SizedBox(
          width: size.width * 0.75,
          child: TextField(
            style: TextStyle(color: textColor),
            controller: phoneController,
            decoration: const InputDecoration(
              hintText: 'phone number',
              hintStyle: TextStyle(color: hintTextColor),
              fillColor: textColor,
            ),
          ),
        ),
      ],
    );
  }

  SizedBox _nextButton() {
    return SizedBox(
      width: 90,
      child: CustomButton(
        action: sendPhoneNumber,
        label: 'NEXT',
      ),
    );
  }

  void pickCountry() {
    showCountryPicker(
      context: context,
      onSelect: (Country _country) {
        setState(() {
          country = _country;
        });
      },
    );
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
    } else {
      showSnackBar(context: context, content: 'Fill out all the fields');
    }
  }
}
