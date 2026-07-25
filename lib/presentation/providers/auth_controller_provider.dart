import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/injection_container.dart';
import '../../domain/entities/farmer_profile_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';

class AuthState {
  final UserEntity? user;
  final FarmerProfileEntity? farmerProfile;
  final bool isLoading;
  final String? errorMessage;
  final bool isGuest;

  const AuthState({
    this.user,
    this.farmerProfile,
    this.isLoading = false,
    this.errorMessage,
    this.isGuest = false,
  });

  bool get isAuthenticated => user != null;
  bool get isProfileComplete => farmerProfile != null && farmerProfile!.isProfileComplete;

  AuthState copyWith({
    UserEntity? user,
    FarmerProfileEntity? farmerProfile,
    bool? isLoading,
    String? errorMessage,
    bool? isGuest,
  }) {
    return AuthState(
      user: user ?? this.user,
      farmerProfile: farmerProfile ?? this.farmerProfile,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isGuest: isGuest ?? this.isGuest,
    );
  }
}

final authControllerProvider = StateNotifierProvider<AuthControllerNotifier, AuthState>((ref) {
  return AuthControllerNotifier(
    authRepository: sl<AuthRepository>(),
    userRepository: sl<UserRepository>(),
  );
});

class AuthControllerNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  AuthControllerNotifier({
    required this.authRepository,
    required this.userRepository,
  }) : super(const AuthState()) {
    checkSession();
  }

  Future<void> checkSession() async {
    state = state.copyWith(isLoading: true);
    final user = await authRepository.restoreSession();
    if (user != null) {
      final profile = await userRepository.getProfile(user.id);
      state = state.copyWith(
        user: user,
        farmerProfile: profile,
        isLoading: false,
        isGuest: authRepository.isGuestUser,
      );
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> sendOtp(String phoneNumber) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final success = await authRepository.sendOtp(phoneNumber);
      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await authRepository.verifyOtp(phoneNumber, otp);
      if (user != null) {
        final profile = await userRepository.getProfile(user.id);
        state = state.copyWith(
          user: user,
          farmerProfile: profile,
          isLoading: false,
          isGuest: false,
        );
        return true;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Invalid OTP entered. Please try again.');
    }
    return false;
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await authRepository.signInWithGoogle();
      if (user != null) {
        final profile = await userRepository.getProfile(user.id);
        state = state.copyWith(
          user: user,
          farmerProfile: profile,
          isLoading: false,
          isGuest: false,
        );
        return true;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Google sign-in failed.');
    }
    return false;
  }

  Future<void> signInAsGuest() async {
    state = state.copyWith(isLoading: true);
    final guestUser = await authRepository.signInAsGuest();
    state = state.copyWith(
      user: guestUser,
      isLoading: false,
      isGuest: true,
    );
  }

  Future<void> updateFarmerProfile(FarmerProfileEntity profile) async {
    state = state.copyWith(isLoading: true);
    await userRepository.saveProfile(profile);
    state = state.copyWith(
      farmerProfile: profile,
      isLoading: false,
    );
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await authRepository.logout();
    state = const AuthState();
  }

  Future<void> deleteAccount() async {
    state = state.copyWith(isLoading: true);
    if (state.user != null) {
      await userRepository.deleteProfile(state.user!.id);
    }
    await authRepository.deleteAccount();
    state = const AuthState();
  }
}
