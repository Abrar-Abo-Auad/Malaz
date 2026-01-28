import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org/reverse';
  static const String _userAgent = 'MalazApp';

  static Future<Map<String, String>> getAddressDetails({
    required double lat,
    required double lng,
    String languageCode = 'ar',
  }) async {
    final url = Uri.parse(
        '$_baseUrl?format=json&lat=$lat&lon=$lng&accept-language=$languageCode&addressdetails=1'
    );

    try {
      final response = await http.get(url, headers: {
        'User-Agent': _userAgent,
        'Accept-Language': languageCode,
      });

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final addr = data['address'] ?? {};

        List<String> addressParts = [];
        final keys = ['amenity', 'building', 'road', 'neighbourhood', 'suburb'];

        for (var key in keys) {
          if (addr[key] != null) addressParts.add(addr[key]);
        }

        String fullAddress = addressParts.join(', ');

        if (fullAddress.isEmpty) {
          fullAddress = addr['tourism'] ?? addr['leisure'] ?? addr['shop'] ?? addr['place'] ?? '';
        }

        String city = (addr['city'] ?? addr['town'] ?? addr['village'] ?? '').toString();
        String governorate = (addr['state'] ?? '').toString();

        fullAddress = _cleanAddress(fullAddress, lat, lng);

        return {
          'city': city,
          'governorate': governorate,
          'address': fullAddress,
        };
      }
    } catch (e) {
      print("Location Service Error: $e");
    }

    return {'city': '', 'governorate': '', 'address': ''};
  }

  static String _cleanAddress(String address, double lat, double lng) {
    if (address.isEmpty) {
      return "${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}";
    }
    return address
        .replaceAll(', ,', ',')
        .replaceAll(RegExp(r',\s*,'), ',')
        .trim()
        .replaceAll(RegExp(r'^,|,$'), '')
        .trim();
  }
}