import 'package:flutter_test_demo/network/utils/network_error.dart';

extension ErrorMessage on NetworkError {
  String get message {
    switch (this) {
      case NetworkError.noInternet:
        return 'No internet connection. Please check your network.';
      case NetworkError.server:
        return 'A server error occurred. Please try again later.';
      case NetworkError.requestTimeout:
        return 'Request timed out. Please try again.';
      case NetworkError.serialization:
        return 'An error occurred while processing data.';
      case NetworkError.unknown:
        return 'An unknown error occurred.';
      case NetworkError.unauthorized:
        return 'Unauthorized access. Please check your credentials.';
      case NetworkError.notFound:
        return 'The requested resource was not found.';
      case NetworkError.forbidden:
        return 'You do not have permission to access this resource.';
      case NetworkError.clientError:
        return 'There was an error with the request. Please try again.';
    }
  }
}
