import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:jwt_authentication/authenticator.dart';
import 'package:jwt_authentication/user.dart';

Handler middleware(Handler handler) {
  return handler.use(
    bearerAuthentication<User>(
      authenticator: (context, token) async {
        final authenticator = context.read<Authenticator>();

        return authenticator.verifyToken(token);
      },
    ),
  );
}
