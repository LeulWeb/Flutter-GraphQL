import 'package:flutter/material.dart';
import 'package:my_app/services/service_graphql.dart';

class DisplayModal extends StatefulWidget {
  const DisplayModal({
    super.key,

    // required this.toggleDone,
    // required this.togglePublic,
  });

  @override
  State<DisplayModal> createState() => _DisplayModalState();
}

class _DisplayModalState extends State<DisplayModal> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  bool is_public = false;
  String user_id = "";
  final GraphQLService _graphQLService = GraphQLService();

  void _submitForm() {
    _graphQLService.createTodo(_title, is_public, user_id);
    Navigator.of(context).pop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: IntrinsicHeight(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
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
                value: is_public,
                onChanged: (value) {
                  setState(() {
                    is_public = !is_public;
                  });
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "user id",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter value";
                  }
                },
                onSaved: (newValue) {
                  user_id = "$newValue";
                },
              ),
              InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _submitForm();
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
                                "New Todo",
                                style: TextStyle(color: Colors.white),
                              )
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
