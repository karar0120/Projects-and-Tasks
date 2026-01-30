import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfigService {
  final FirebaseRemoteConfig _firebaseRemoteConfig = FirebaseRemoteConfig.instance;

  String getString(String key) => _firebaseRemoteConfig.getString(key);
  bool getBool(String key) => _firebaseRemoteConfig.getBool(key);
  int getInt(String key) => _firebaseRemoteConfig.getInt(key);
  double getDouble(String key) => _firebaseRemoteConfig.getDouble(key);

  Future _setConfigSettings() async => _firebaseRemoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval:const Duration(minutes: 720),
    ),
  );

  Future _setDefaults() async => _firebaseRemoteConfig.setDefaults(
    const {
      'upload_max_retry_attempts': 5, // Default max retry attempts for upload jobs
    },
  );

  Future initialize() async {
    await _setConfigSettings();
    await _setDefaults(); // Set defaults before fetch
    await _firebaseRemoteConfig.fetch();

    await _firebaseRemoteConfig.activate();
  }
}
