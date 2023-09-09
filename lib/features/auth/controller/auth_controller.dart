import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/models/user_model.dart';
import '../repository/auth_repository.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({
    required this.authRepository,
    required this.ref,
  });

  Future<UserModel?> getUserData() async {
    return await authRepository.getCurrentUserData();
  }

  void _executeWithContext({
    required BuildContext context,
    required Function(BuildContext) callback,
  }) {
    callback(context);
  }

  void signInWithPhone(BuildContext context, String phoneNumber) {
    _executeWithContext(
      context: context,
      callback: (ctx) => authRepository.signInWithPhone(ctx, phoneNumber),
    );
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP) {
    _executeWithContext(
      context: context,
      callback: (ctx) => authRepository.verifyOTP(
        context: ctx,
        verificationId: verificationId,
        userOTP: userOTP,
      ),
    );
  }

  void saveUserDataToFirebase(
      BuildContext context, String name, File? profilePic) {
    _executeWithContext(
      context: context,
      callback: (ctx) => authRepository.saveUserDataToFirebase(
        name: name,
        profilePic: profilePic,
        ref: ref,
        context: ctx,
      ),
    );
  }

  Stream<UserModel> userDataById(String userId) {
    return authRepository.userData(userId);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }
}
