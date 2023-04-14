import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQlConfig {
  static HttpLink httpLink =
      HttpLink("https://rapid-silkworm-96.hasura.app/v1/graphql");
  static AuthLink authLink = AuthLink(
      getToken: () async =>
          "Tp8Y0c35TzsKv1AuGZdWBhTULYxXWLPqKADvpC3rzJjD8UZJSvFe2QtLR2xGs684",
      headerKey: "x-hasura-admin-secret");
  static Link link = authLink.concat(httpLink);

  GraphQLClient clientToQuery() => GraphQLClient(
        link: link,
        cache: GraphQLCache(
         
        ),
      );
}
