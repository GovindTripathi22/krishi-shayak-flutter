import '../../core/logger/app_logger.dart';
import '../../core/services/firebase/firestore_service.dart';
import '../../domain/entities/farmer_profile_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/farmer_profile_model.dart';

class UserRepositoryImpl implements UserRepository {
  final IFirestoreService firestoreService;
  final Map<String, FarmerProfileEntity> _inMemoryCache = {};

  UserRepositoryImpl({required this.firestoreService});

  @override
  Future<FarmerProfileEntity?> getProfile(String userId) async {
    AppLogger.info('UserRepositoryImpl: Fetching profile for $userId');
    if (_inMemoryCache.containsKey(userId)) {
      return _inMemoryCache[userId];
    }
    
    final docData = await firestoreService.getDocument('farmers', userId);
    if (docData != null) {
      final model = FarmerProfileModel.fromJson(docData);
      _inMemoryCache[userId] = model;
      return model;
    }
    return null;
  }

  @override
  Future<void> saveProfile(FarmerProfileEntity profile) async {
    AppLogger.info('UserRepositoryImpl: Saving profile for ${profile.userId}');
    final model = FarmerProfileModel.fromEntity(profile);
    _inMemoryCache[profile.userId] = profile;
    await firestoreService.setDocument('farmers', profile.userId, model.toJson());
  }

  @override
  Future<void> updateProfile(FarmerProfileEntity profile) async {
    AppLogger.info('UserRepositoryImpl: Updating profile for ${profile.userId}');
    await saveProfile(profile);
  }

  @override
  Future<void> deleteProfile(String userId) async {
    AppLogger.info('UserRepositoryImpl: Deleting profile for $userId');
    _inMemoryCache.remove(userId);
  }
}
