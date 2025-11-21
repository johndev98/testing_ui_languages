import 'package:isar/isar.dart';

part 'user_profile.g.dart';

@Collection()
class UserProfile {
  Id id = Isar.autoIncrement; // Isar auto-increment id

  // Onboarding fields
  String? gender;
  double? weight;
  int? height;
  int? birthYear;
  String? goal;
  double? targetWeight;
  String? diet;
  double? speed;
  int? activityLevel;

  // Extra for future (Google Sign-In)
  String? googleId;
  String? name;
  String? avatarUrl;

  DateTime? updatedAt;

  UserProfile({
    this.activityLevel,
    this.gender,
    this.weight,
    this.height,
    this.birthYear,
    this.goal,
    this.targetWeight,
    this.diet,
    this.speed,
    this.googleId,
    this.name,
    this.avatarUrl,
    this.updatedAt,
  });
}
