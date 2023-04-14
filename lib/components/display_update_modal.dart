import 'package:flutter/material.dart';
import 'package:my_app/services/service_graphql.dart';

//TODO: Update Todo App

class DisplayUpdateModal extends StatefulWidget {
  final String title;
   bool is_public;
  final int id;
   bool is_done;

   DisplayUpdateModal({
    super.key,
    required this.title,
    required this.is_public,
    required this.id,
    required this.is_done,
  });

  @override
  State<DisplayUpdateModal> createState() => _DisplayUpdateModal();
}

class _DisplayUpdateModal extends State<DisplayUpdateModal> {
  final _formKey = GlobalKey<FormState>();
  final GraphQLService _graphQLService = GraphQLService();

  // void _submitForm() {
  //   _graphQLService.createTodo(_title, is_public, user_id);
  //   Navigator.of(context).pop();
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    String _title = widget.title;
    // bool is_public = widget.is_public;
    // bool is_done = widget.is_done;
    // int id = widget.id;
    // TextEditingController _titleController;

    return AlertDialog(
      content: IntrinsicHeight(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.title,
                decoration: const InputDecoration(hintText: "what todo?"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter value";
                  }
                },
                onSaved: (newValue) {
                  _title = newValue!;
                },
              ),
              SwitchListTile(
                title: const Text("show for public"),
                // secondary: Icon(Icons.public),
                value: widget.is_public,
                onChanged: (value) {
                  setState(() {
                    widget.is_public = !widget.is_public;
                  });
                },
              ),
              SwitchListTile(
                title: const Text("did you finish"),
                // secondary: Icon(Icons.public),
                value: widget.is_done,
                onChanged: (value) {
                  setState(() {
                    widget.is_done = !widget.is_done;
                  });
                },
              ),
              InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _graphQLService.updateTodo(_title, widget.is_public, widget.id, widget.is_done);
                    setState(() {
                      
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              Text(
                                "Update todo",
                                style: TextStyle(color: Colors.white),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
