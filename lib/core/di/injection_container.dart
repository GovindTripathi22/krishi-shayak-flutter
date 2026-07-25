import 'package:get_it/get_it.dart';

import '../data/datasources/auth_remote_datasource.dart';
import '../data/datasources/scheme_local_datasource.dart';
import '../data/datasources/scheme_remote_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/bookmark_repository_impl.dart';
import '../data/repositories/category_repository_impl.dart';
import '../data/repositories/chat_repository_impl.dart';
import '../data/repositories/checklist_repository_impl.dart';
import '../data/repositories/document_repository_impl.dart';
import '../data/repositories/eligibility_repository_impl.dart';
import '../data/repositories/government_scheme_repository_impl.dart';
import '../data/repositories/search_repository_impl.dart';
import '../data/repositories/user_repository_impl.dart';

import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/bookmark_repository.dart';
import '../domain/repositories/category_repository.dart';
import '../domain/repositories/chat_repository.dart';
import '../domain/repositories/checklist_repository.dart';
import '../domain/repositories/document_repository.dart';
import '../domain/repositories/eligibility_repository.dart';
import '../domain/repositories/government_scheme_repository.dart';
import '../domain/repositories/search_repository.dart';
import '../domain/repositories/user_repository.dart';

import '../services/ai/gemini_ai_service.dart';
import '../services/ai/gemini_document_analyzer.dart';
import '../services/ai/rag_search_engine.dart';
import '../services/document/ocr_text_extractor.dart';
import '../services/firebase/analytics_service.dart';
import '../services/firebase/auth_service.dart';
import '../services/firebase/cloud_messaging_service.dart';
import '../services/firebase/crashlytics_service.dart';
import '../services/firebase/firestore_service.dart';
import '../services/firebase/storage_service.dart';
import '../services/network/connectivity_service.dart';
import '../services/storage/preferences_service.dart';

final sl = GetIt.instance;

Future<void> initDependencyInjection() async {
  // Services & Network
  await PreferencesService.init();

  sl.registerLazySingleton<ConnectivityNotifier>(() => ConnectivityNotifier());
  sl.registerLazySingleton<IAuthService>(() => FirebaseAuthService());
  sl.registerLazySingleton<IFirestoreService>(() => FirebaseFirestoreService());
  sl.registerLazySingleton<ICloudMessagingService>(() => FirebaseCloudMessagingService());
  sl.registerLazySingleton<IAnalyticsService>(() => FirebaseAnalyticsService());
  sl.registerLazySingleton<ICrashlyticsService>(() => FirebaseCrashlyticsService());
  sl.registerLazySingleton<IStorageService>(() => FirebaseStorageService());

  sl.registerLazySingleton<GeminiAiService>(() => GeminiAiService());
  sl.registerLazySingleton<OcrTextExtractor>(() => OcrTextExtractor());
  sl.registerLazySingleton<GeminiDocumentAnalyzer>(() => GeminiDocumentAnalyzer());

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl());
  sl.registerLazySingleton<SchemeRemoteDataSource>(() => SchemeRemoteDataSourceImpl());
  sl.registerLazySingleton<SchemeLocalDataSource>(() => SchemeLocalDataSourceImpl());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(firestoreService: sl()));
  
  sl.registerLazySingleton<GovernmentSchemeRepository>(() => GovernmentSchemeRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        connectivityNotifier: sl(),
      ));

  sl.registerLazySingleton<BookmarkRepository>(() => BookmarkRepositoryImpl(
        localDataSource: sl(),
        schemeRepository: sl(),
      ));

  sl.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl());

  sl.registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl(
        schemeRepository: sl(),
      ));

  sl.registerLazySingleton<EligibilityRepository>(() => EligibilityRepositoryImpl(
        schemeRepository: sl(),
      ));

  sl.registerLazySingleton<RagSearchEngine>(() => RagSearchEngine(
        schemeRepository: sl(),
      ));

  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl());

  sl.registerLazySingleton<DocumentRepository>(() => DocumentRepositoryImpl(
        ocrExtractor: sl(),
        analyzer: sl(),
      ));

  sl.registerLazySingleton<ChecklistRepository>(() => ChecklistRepositoryImpl(
        schemeRepository: sl(),
      ));
}
