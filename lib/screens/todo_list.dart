import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app_rest_api/screens/add_page.dart';
import 'package:todo_app_rest_api/services/todo_service.dart';
import 'package:todo_app_rest_api/widget/todo_card.dart';

import '../utils/snackbar_helper.dart';

class TodoListPage extends StatefulWidget {

  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;

  List items = [];
  @override
  void initState() {
    super.initState() ;
    fetchTodo();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Todo List",
        style: GoogleFonts.notoSans(),
        ),
        backgroundColor: Color(0xFFc3e6fe),
      ),
      body: Visibility(
      visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
        onRefresh: fetchTodo,
      child: Visibility(
         visible: items.isNotEmpty,
        replacement: Center(
          child: Text(
          'No tasks yet',
            style: GoogleFonts.notoSans(
              textStyle: const TextStyle(fontSize: 25)
            ),
          ),
        ),
      child: ListView.builder(
        itemCount: items.length,
        padding: EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final item = items[index] as Map;
       return TodoCard(
           index: index,
           deleteById: deleteById,
           navigateEdit: navigateToEditPage,
           item: item,
       );
      },
      ),
      ),
      ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFc3e6fe),
          onPressed: navigateToAddPage,
          child: const Icon(Icons.add,
          size: 27,
          color: Color(0xFF152237),
          ),

      ),
    );
  }

Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
        builder: (context) => AddTodoPage(todo: item),
    );
     await Navigator.push(context, route);
     setState(() {
       isLoading = true;
     });
     fetchTodo();
}

   Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
   }

  Future<void>deleteById(String id) async {
    final isSuccess = await TodoService.deleteById(id);
    if(isSuccess){
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    }else{
      // Show error
      showErrorMessage(context, message: 'Deletion Failed');
    }
  }

Future<void> fetchTodo()async{


    final response = await TodoService.fetchTodos();

    if (response !=null) {
   setState(() {
     items = response;
   });
    }else{
      showErrorMessage(context, message: 'Something went wrong');
    }
    setState(() {
      isLoading = false;
    });
}
}
