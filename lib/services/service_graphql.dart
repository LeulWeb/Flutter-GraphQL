import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:my_app/config_graphql.dart';
import 'package:my_app/constants/query.dart';
import '../models/model_todo.dart';

class GraphQLService {
  //this is where we do our crud application
  static GraphQlConfig graphQLConfig = GraphQlConfig();
  GraphQLClient client = graphQLConfig.clientToQuery();

  //?Getting the Todo
  Future<List<TodoModel>> getTodo() async {
    //we do not know what will come from the backend

    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy
              .cacheAndNetwork, //this will cache and then update with network
          document: gql(QueryDoc.get_todo),
        ),
      );

      //check our result
      if (result.hasException) {
        throw Exception(result.exception);
      }

      //check is result is empty
      List? res = result.data?['todos'];

      //if the result is empty or null we return empty list
      if (res == null || res.isEmpty) {
        return [];
      }

      //else if the result is not empty we convert it to Todo model
      List<TodoModel> todos = res
          .map(
            (e) => TodoModel.fromMap(e),
          )
          .toList();
      return todos;
    } catch (e) {
      throw Exception(e);
    }
  }

  //! Deleting the Todo
  Future<String> deleteTodo(int id) async {
    //we do not know what will come from the backend

    try {
      QueryResult result = await client.mutate(
        MutationOptions(
            fetchPolicy: FetchPolicy
                .cacheAndNetwork, //this will cache and then update with network
            document: gql('''
              mutation MyMutation(\$id: Int!) {
  delete_todos_by_pk(id: \$id) {
    title
    id
  }
}

            '''),
            variables: {"id": id}),
      );

      //check our result
      if (result.hasException) {
        throw Exception(result.exception);
      }

      //check is result is empty
      String? res = result.data?['delete_todos_by_pk']['title'];

      //if the result is empty or null we return empty list
      if (res == null || res.isEmpty) {
        return "";
      }
      return res;
    } catch (e) {
      throw Exception(e);
    }
  }

  //* Creating new Todo
  Future<String> createTodo(
      String title, bool is_public, String user_id) async {
    //we do not know what will come from the backend

    try {
      QueryResult result = await client.mutate(
        MutationOptions(
            fetchPolicy: FetchPolicy
                .cacheAndNetwork, //this will cache and then update with network
            document: gql('''
              mutation MyMutation(\$is_public: Boolean , \$title: String, \$users_id: String) {
  insert_todos_one(object: {is_public: \$is_public, title: \$title, users_id: \$users_id}) {
    users_id
    title
    user {
      name
    }
  }
}
            '''),
            variables: {
              "is_public": is_public,
              "title": title,
              "users_id": user_id
            }),
      );

      //check our result
      if (result.hasException) {
        throw Exception(result.exception);
      }

      //check is result is empty
      String? res = result.data?['insert_todos_one']['title'];

      //if the result is empty or null we return empty list
      if (res == null || res.isEmpty) {
        return "";
      }
      return res;
    } catch (e) {
      throw Exception(e);
    }
  }

  //Updating a todo
  Future<String> updateTodo(String title, bool is_public,
      int id, bool is_done) async {
    //we do not know what will come from the backend

    try {
      QueryResult result = await client.mutate(
        MutationOptions(
            fetchPolicy: FetchPolicy.networkOnly, //this will cache and then update with network
            document: gql('''
              mutation MyMutation(\$id: Int!, \$title: String,  \$is_public: Boolean, \$is_done: Boolean) {
  update_todos_by_pk(pk_columns: {id: \$id}, _set: {is_done: \$is_done, is_public: \$is_public, title: \$title}) {
    title
    is_done
    is_public
    user {
      name
    }
  }
}

            '''),
            variables: {
              "id": id,
              "title": title,
              "is_done": is_done,
              "is_public": is_public
            }),
      );

      //check our result
      if (result.hasException) {
        throw Exception(result.exception);
      }

      //check is result is empty
      String? res = result.data?['update_todos_by_pk']['title'];

      //if the result is empty or null we return empty list
      if (res == null || res.isEmpty) {
        return "";
      }
      return res;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
