import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/database/todo_db.dart';
import 'package:intl/intl.dart';

import '../model/todo.dart';
import '../widget/create_todo_widget.dart';

class TodosPage extends StatefulWidget {
  const TodosPage({Key? key}) : super(key: key);

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  Future<List<Todo>>? futureTodos;
  final todoDB = TodoDB();

  final dio = Dio();


  @override
  void initState() {
    super.initState();
    fetchTodos();
    fetchData();
  }

  void fetchTodos() {
    setState(() {
      futureTodos = todoDB.fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo List'),
      ),
      body: FutureBuilder<List<Todo>>(
        future: futureTodos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final todos = snapshot.data!;
            return todos.isEmpty
                ? const Center(
                    child: Text(
                      'No todos..',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 28.0),
                    ),
                  )
                : ListView.separated(
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      final subtitle = DateFormat('yyyy/MM/dd').format(
                          DateTime.parse(todo.updatedAt ?? todo.createdAt));
                      return ListTile(
                        title: Text(
                          todo.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // subtitle: Text(subtitle),
                        // trailing: IconButton(
                        //   onPressed: () async {
                        //     await todoDB.delete(todo.id);
                        //     fetchTodos();
                        //   },
                        //   icon: const Icon(
                        //     Icons.delete,
                        //     color: Colors.red,
                        //   ),
                        // ),
                        onTap: () {
                          // showDialog(
                          //     context: context,
                          //     builder: (context) => CreateTodoWidget(
                          //         todo: todo,
                          //         onSubmit: (title) async {
                          //           await todoDB.update(
                          //               id: todo.id, title: title);
                          //           fetchTodos();
                          //           if (!mounted) return;
                          //           Navigator.pop(context);
                          //         }));
                        },
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 12.0,
                        ),
                    itemCount: todos.length);
          }
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: () {
      //     showDialog(
      //         context: context,
      //         builder: (_) => CreateTodoWidget(
      //               onSubmit: (title) async {
      //                 await todoDB.create(title: title);
      //                 if (!mounted) return;
      //                 fetchTodos();
      //                 Navigator.of(context).pop();
      //               },
      //             ));
      //   },
      // ),
    );
  }

  void getDataAndSetToDb(List items) async{

    final existingData = await todoDB.query();

    if(existingData.isEmpty){
      await todoDB.clearDatabase();
      for (var element in items) {
        await todoDB.create(title: element['title']);
        if (!mounted) return;

      }
      fetchTodos();
    }else {

    }

  }

  void fetchData() async {
    try {
      final response = await dio.get(
        'https://api.ganjoor.net/api/ganjoor/poet?url=%2Fhafez',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        getDataAndSetToDb(data['cat']['children']);
      } else {
        // Handle error
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any Dio errors
      print('Error: $e');
    }
  }

}
