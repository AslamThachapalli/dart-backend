import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:jwt_authentication/authenticator.dart';
import 'package:jwt_authentication/exceptions.dart';

Future<Response> onRequest(RequestContext context) {
  final method = context.request.method;

  return switch (method) {
    HttpMethod.post => _post(context),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _post(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final email = body['email'] as String?;
  final password = body['password'] as String?;

  if (email == null || password == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final authenticator = context.read<Authenticator>();

  try {
    final user = authenticator.findOne(email: email, password: password);

    final jwt = authenticator.generateToken(user);

    return Response.json(
      statusCode: HttpStatus.accepted,
      body: {
        'token': jwt,
      },
    );
  } on UserNotFound {
    return Response(
      statusCode: HttpStatus.unauthorized,
      body: 'Invalid Credentials',
    );
  }
}
