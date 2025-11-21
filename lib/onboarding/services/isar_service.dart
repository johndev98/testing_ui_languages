import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../model/user_profile.dart';

class IsarService {
  static Isar? _isar;

  static Future<Isar> openDB() async {
    if (_isar != null) return _isar!;
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [UserProfileSchema],
      directory: dir.path,
    );
    return _isar!;
  }

  /// Use single profile (id = 1) for simplicity.
  static Future<UserProfile?> getUserProfile() async {
    final isar = await openDB();
    return await isar.userProfiles.get(1);
  }

  static Future<void> saveUserProfile(UserProfile profile) async {
    final isar = await openDB();
    // ensure id==1 so we always update same profile
    if (profile.id == 0) {
      profile.id = 1;
    } else {
      profile.id = 1;
    }
    profile.updatedAt = DateTime.now();
    await isar.writeTxn(() async {
      await isar.userProfiles.put(profile);
    });
  }
}
