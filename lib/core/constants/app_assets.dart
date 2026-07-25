/// Centralized asset management for AgriSathi AI
abstract class AppAssets {
  static const String _iconsPath = 'assets/icons';
  static const String _illustrationsPath = 'assets/illustrations';
  static const String _imagesPath = 'assets/images';
  static const String _lottiePath = 'assets/lottie';

  // App Logo
  static const String appLogo = '$_imagesPath/app_logo.png';
  static const String appLogoSvg = '$_iconsPath/app_logo.svg';

  // Onboarding Illustrations
  static const String onboardingIntro = '$_illustrationsPath/onboarding_intro.png';
  static const String onboardingSchemes = '$_illustrationsPath/onboarding_schemes.png';
  static const String onboardingAiVoice = '$_illustrationsPath/onboarding_ai_voice.png';

  // Feature Icons
  static const String iconSprout = '$_iconsPath/sprout.svg';
  static const String iconChat = '$_iconsPath/chat.svg';
  static const String iconDocument = '$_iconsPath/document.svg';
  static const String iconMic = '$_iconsPath/mic.svg';
  static const String iconLanguage = '$_iconsPath/language.svg';

  // Lottie Animations
  static const String loadingSprout = '$_lottiePath/loading_sprout.json';
  static const String voiceWave = '$_lottiePath/voice_wave.json';
  static const String emptyState = '$_lottiePath/empty_state.json';
  static const String errorState = '$_lottiePath/error_state.json';
}
