import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenHandler {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  TokenHandler();

  Future<void> saveToken(String token) async {
    await storage.write(key: 'auth_token', value: token);
  }
  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }
  Future<void> deleteToken() async {
    await storage.delete(key: 'auth_token');
  }
  Future<bool> hasToken() async {
    String? token = await storage.read(key: 'auth_token');
    return token != null;
  }
}