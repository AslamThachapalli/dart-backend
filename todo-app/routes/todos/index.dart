import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todos_data_source/todos_data_source.dart';

FutureOr<Response> onRequest(RequestContext context) {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context);
    case HttpMethod.post:
      return _post(context);
    case HttpMethod.put:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context) async {
  final datasource = context.read<TodosDataSource>();
  final todos = await datasource.readAll();
  return Response.json(body: todos);
}

Future<Response> _post(RequestContext context) async {
  final datasource = context.read<TodosDataSource>();
  final todoJson = await context.request.json() as Map<String, dynamic>;

  final newTodo = Todo.fromJson(todoJson);

  return Response.json(
      statusCode: HttpStatus.created, body: await datasource.create(newTodo));
}
