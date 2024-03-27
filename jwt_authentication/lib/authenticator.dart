import 'dart:math';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:jwt_authentication/exceptions.dart';
import 'package:jwt_authentication/user.dart';

class Authenticator {
  final List<User> _users = [];

  User create({
    required String email,
    required String password,
  }) {
    if (_users.any((user) => user.username == email)) {
      throw UserAlreadyExists();
    } else {
      final random = Random();

      final id = random.nextInt(100000);
      final newUser = User(
        id: '$id',
        username: email,
        password: password,
      );

      _users.add(newUser);

      return newUser;
    }
  }

  User findOne({
    required String email,
    required String password,
  }) {
    return _users.firstWhere(
      (user) => user.username == email && user.password == password,
      orElse: () => throw UserNotFound(),
    );
  }

  static final _jwtSecret = SecretKey('mySecretKey');

  String generateToken(User user) {
    final jwt = JWT({
      'id': user.id,
      'username': user.username,
    });

    return jwt.sign(_jwtSecret);
  }

  User? verifyToken(String token) {
    try {
      final payload = JWT.verify(token, _jwtSecret);
      final payloadData = payload.payload as Map<String, dynamic>;

      final userId = payloadData['id'];
      final user = _users.firstWhere((user) => user.id == userId);

      return user;
    } catch (_) {
      return null;
    }
  }
}
