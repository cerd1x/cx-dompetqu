import 'package:graphql/client.dart';

/// Ekstrak pesan error pertama dari GraphQL `QueryResult`.
///
/// Prioritas: error GraphQL → link/transport error (misal timeout) → fallback.
String gqlErrorMessage(QueryResult result, {required String fallback}) {
  final exception = result.exception;
  if (exception == null) return fallback;
  final first = exception.graphqlErrors.isNotEmpty
      ? exception.graphqlErrors.first.message
      : null;
  if (first != null) return first;
  final linkError = exception.linkException;
  if (linkError != null) return linkError.toString();
  return fallback;
}
