//this is just a model to represent  what our todo may look like

class TodoModel {
  final int id;
  final String title;
  final bool is_public;
  final bool is_done;
  final String created_at;
  final String name;

  TodoModel({
    required this.id,
    required this.title,
    required this.is_public,
    required this.is_done,
    required this.created_at,
    required this.name, 
  });



  //Method for converting the backend result doc to model 

  static TodoModel fromMap( Map map)=> TodoModel(
    title:map['title'],
    id: map['id'],
    is_done : map['is_done'],
    is_public : map['is_public'],
    created_at : map['created_at'],
    name:  map['user']['name']
    
  );
}
