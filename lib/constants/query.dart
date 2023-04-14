class QueryDoc {
  static const String get_todo = """
  query MyQuery {
  todos{
    id
    title
    is_done
    is_public
    created_at
    user{
      name
    }
  }
}
  """;

  static const String delete_todo = """
    mutation MyMutation(\$id: Int = 10) {
  delete_todos_by_pk(id: \$id) {
    id
    title
  }
}
""";






}
