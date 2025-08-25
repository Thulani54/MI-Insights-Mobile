import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static final Map<String, String> preferencesKeys = {
    "cec_client_id_key": "cec_client_id",
    "address_1": "address_1",
    "address_2": "address_2",
    "city": "city",
    "province": "province",
    "country": "country",
    "area_code": "area_code",
    "postal_address_1": "postal_address_1",
    "postal_address_2": "postal_address_2",
    "postal_city": "postal_city",
    "postal_province": "postal_province",
    "postal_country": "postal_country",
    "postal_code": "postal_code",
    "tel_no": "tel_no",
    "cell_no": "cell_no",
    "comp_name": "comp_name",
    "vat_number": "vat_number",
    "client_fsp": "client_fsp",
  };

  static Future<bool> savePreference(String key, dynamic value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferencesKeys.containsKey(key)) {
      if (value is int) {
        return await preferences.setInt(preferencesKeys[key]!, value);
      } else if (value is String) {
        return await preferences.setString(preferencesKeys[key]!, value);
      }
    }
    return false; // Invalid key or value type
  }

  static Future<dynamic?> getPreference(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferencesKeys.containsKey(key)) {
      String? preferencesKey = preferencesKeys[key];
      if (preferencesKey != null) {
        if (preferencesKey.contains("int")) {
          return preferences.getInt(preferencesKey);
        } else if (preferencesKey.contains("String")) {
          return preferences.getString(preferencesKey);
        }
      }
    }
    return null; // Invalid key
  }
}
