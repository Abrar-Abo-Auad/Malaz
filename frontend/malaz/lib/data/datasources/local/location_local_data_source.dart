import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';

abstract class LocationLocalDataSource {
  Future<void> cacheCoordinates(double lat, double lng);
  Future<void> cacheUserAddress(String address);
  Future<Map<String, double?>> getCachedCoordinates();
  Future<String?> getCachedAddress();
  Future<void> clearLocationAndAddress();
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  final SharedPreferences _prefs;

  LocationLocalDataSourceImpl(this._prefs);

  @override
  Future<void> cacheCoordinates(double lat, double lng) async {
    await Future.wait([
      _prefs.setDouble(AppConstants.latKey, lat),
      _prefs.setDouble(AppConstants.lngKey, lng),
    ]);
  }

  @override
  Future<Map<String, double?>> getCachedCoordinates() async {
    final lat = _prefs.getDouble(AppConstants.latKey);
    final lng = _prefs.getDouble(AppConstants.lngKey);

    return {'lat': lat, 'lng': lng};
  }

  @override
  Future<void> cacheUserAddress(String address) async {
    await _prefs.setString(AppConstants.addressKey, address);
  }

  @override
  Future<String?> getCachedAddress() async {
    return _prefs.getString(AppConstants.addressKey);
  }

  @override
  Future<void> clearLocationAndAddress() async {
    await Future.wait([
      _prefs.remove(AppConstants.addressKey),
      _prefs.remove(AppConstants.latKey),
      _prefs.remove(AppConstants.lngKey),
    ]);
  }
}