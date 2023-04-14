import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:my_app/components/display_update_modal.dart';
import 'package:my_app/services/service_graphql.dart';
import './models/model_todo.dart';
import 'package:intl/intl.dart';

import 'components/display_modal.dart';

void main() async {
  //intialize Hive

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Title',
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.purple),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  List<TodoModel>? _todos;
  final GraphQLService _graphQLService = GraphQLService();

  @override
  void initState() {
    super.initState();
    _load();
  }

   void  _load() async {
    _todos = null;
    _todos = await _graphQLService.getTodo();
    //this is will update our ui after we fetch the data
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _idController.dispose();
    super.dispose();
  }


  // void _refresh(){
  //   _load();
  // }

  void displayForm() {
    showDialog(
        context: context,
        builder: (ctx) {
          return DisplayModal();
        });
  }

  void displayUpdateForm(
      {required String title,
      required int id,
      required bool is_done,
      required bool is_public}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return DisplayUpdateModal(
            title: title,
            id: id,
            is_done: is_done,
            is_public: is_public,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
          _load();
        },
        child: Column(
          children: [
            Container(
              child: _todos == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _todos!.isEmpty
                      ? const Center(
                          child: Text("No Todo is Found"),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: _todos!.length,
                            itemBuilder: (context, index) {
                              return Slidable(
                                endActionPane: ActionPane(
                                  motion: const StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      backgroundColor: Colors.red,
                                      label: "Delete",
                                      onPressed: (context) {
                                        // ();
                                        _graphQLService
                                            .deleteTodo(_todos![index].id);
                                        _load();
                                      },
                                      icon: Icons.delete,
                                    ),
                                    SlidableAction(
                                      backgroundColor: Colors.blue,
                                      label: "Edit",
                                      onPressed: (context) {
                                        displayUpdateForm(
                                          title: _todos![index].title,
                                          id: _todos![index].id,
                                          is_done: _todos![index].is_done,
                                          is_public: _todos![index].is_public,
                                        );
                                      },
                                      icon: Icons.edit,
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  title: Text(_todos![index].title),
                                  leading: _todos![index].is_public
                                      ? const Icon(Icons.public)
                                      : const Icon(Icons.person),
                                  trailing: _todos![index].is_done
                                      ? const Icon(
                                          Icons.verified,
                                          color: Colors.greenAccent,
                                        )
                                      : const Icon(
                                          Icons.pending,
                                          color: Colors.blueAccent,
                                        ),
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _todos![index].name,
                                      ),
                                      Text(DateFormat('dd/mm/yyyy').format(
                                          (DateTime.parse(
                                              _todos![index].created_at))))
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: displayForm,
        tooltip: "Add New Todo",
        child: const Icon(Icons.add),
      ),
    );
  }
}
