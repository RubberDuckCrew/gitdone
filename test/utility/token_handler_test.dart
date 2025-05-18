import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gitdone/core/models/token_handler.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockStorage;
  late TokenHandler tokenHandler;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    tokenHandler = TokenHandler();
    tokenHandler.storage = mockStorage;
  });

  group('TokenHandler Tests', () {
    test('saves token successfully', () async {
      const token = 'test_token';
      when(
        () => mockStorage.write(key: 'auth_token', value: token),
      ).thenAnswer((_) async => {});
      await tokenHandler.saveToken(token);
      verify(
        () => mockStorage.write(key: 'auth_token', value: token),
      ).called(1);
    });

    test('retrieves token successfully', () async {
      const token = 'test_token';
      when(
        () => mockStorage.read(key: 'auth_token'),
      ).thenAnswer((_) async => token);
      final result = await tokenHandler.getToken();
      expect(result, token);
      verify(() => mockStorage.read(key: 'auth_token')).called(1);
    });

    test('deletes token successfully', () async {
      when(
        () => mockStorage.delete(key: 'auth_token'),
      ).thenAnswer((_) async => {});
      await tokenHandler.deleteToken();
      verify(() => mockStorage.delete(key: 'auth_token')).called(1);
    });

    test('checks if token exists', () async {
      when(
        () => mockStorage.read(key: 'auth_token'),
      ).thenAnswer((_) async => 'test_token');
      final result = await tokenHandler.hasToken();
      expect(result, true);
      verify(() => mockStorage.read(key: 'auth_token')).called(1);
    });

    test('checks if token does not exist', () async {
      when(
        () => mockStorage.read(key: 'auth_token'),
      ).thenAnswer((_) async => null);
      final result = await tokenHandler.hasToken();
      expect(result, false);
      verify(() => mockStorage.read(key: 'auth_token')).called(1);
    });
  });
}
