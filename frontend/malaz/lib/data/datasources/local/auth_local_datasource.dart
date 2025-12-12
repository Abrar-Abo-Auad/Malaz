import 'dart:convert';

import 'package:malaz/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/errors/exceptions.dart';

abstract class AuthLocalDatasource {
  Future<void> cacheToken(String token);
  Future<String?> getCachedToken();
  Future<void> clearToken();
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
}
const _KEY_TOKEN = 'CACHED_TOKEN';
const _KEY_USER = 'CACHED_USER';

class AuthLocalDataSourceImpl implements AuthLocalDatasource {
  final SharedPreferences sharedPreferences;
  
  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheToken(String token) async {
    final ok = await sharedPreferences.setString(_KEY_TOKEN, token);
    if (!ok) throw CacheException('Failed to cache token');
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    final jsonStr = jsonEncode(user.toJson());
    final ok = await sharedPreferences.setString(_KEY_USER, jsonStr);
    if (!ok) throw CacheException('Failed to cache user');
  }

  @override
  Future<void> clearToken() async {
    await sharedPreferences.remove(_KEY_TOKEN);
    await sharedPreferences.remove(_KEY_USER);
  }

  @override
  Future<String?> getCachedToken() async {
    return sharedPreferences.getString(_KEY_TOKEN);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonStr = sharedPreferences.getString(_KEY_USER);
    if (jsonStr == null) return null;
    try {
      final Map<String, dynamic> map = jsonDecode(jsonStr);
      return UserModel.fromJson(map);
    } catch (e) {
      throw CacheException('Failed to read cached user');
    }
  }
}