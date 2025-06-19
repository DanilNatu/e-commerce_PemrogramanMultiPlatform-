import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project2/UserScreen/loginRegister.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class GraphQLConfig {
  static final HttpLink _httpLink = HttpLink(
    'http://10.0.2.2:8080/graphql',
  );

  static final AuthLink _authLink = AuthLink(
    getToken: () async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      return token != null ? 'Bearer $token' : null;
    },
  );

  static final ErrorLink _errorLink = ErrorLink(
    onException: (request, forward, exception) async* {
      final originalException = exception.originalException;
      if (originalException != null &&
          originalException.toString().contains("FormatException")) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');

        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const FirstScreen(value: true)),
          (route) => false,
        );
      }
      yield* forward(request);
    },
  );

  static final Link _link = _errorLink.concat(_authLink).concat(_httpLink);
  

  static final ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: _link,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );
}
