import 'package:dart_frog/dart_frog.dart';

import 'package:jwt_authentication/authenticator.dart';

final _authenticator = Authenticator();

Handler middleware(Handler handler) {
  return handler.use(
    provider<Authenticator>(
      (_) => _authenticator,
    ),
  );
}
