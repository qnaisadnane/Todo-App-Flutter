import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app_rest_api/services/todo_service.dart';
import '../utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    super.key,
  this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo !=null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isEdit? 'Edit Todo' : 'Add Todo',
          style: GoogleFonts.notoSans(),
        ),
        backgroundColor: Color(0xFFc3e6fe),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Title',
              hintStyle: GoogleFonts.notoSans(
                  textStyle: const TextStyle(fontSize: 20)
              ),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Description',
              hintStyle: GoogleFonts.notoSans(
                  textStyle: const TextStyle(fontSize: 20)
              ),
            ),

          ),
          SizedBox(height: 20),
           ElevatedButton(
              onPressed: isEdit ? updateData: submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFc3e6fe),
                    minimumSize: Size(60, 40),
                    padding: EdgeInsets.all(20.0),
                    fixedSize: Size(200, 80),
                  ),
                  child: Text(
                    isEdit? 'Update' : 'Submit',
                    style: GoogleFonts.notoSans(
                        textStyle: const TextStyle(fontSize: 20,
                        color: Colors.black,
                        )

                    ),
                  ),



              )
              ],
          ),

      );
  }
  
  Future<void> updateData() async {
    // Get the data from form
    final todo = widget.todo;
    if (todo == null) {
      print('You can not call updated without todo data');
      return;
    }
    final id = todo['_id'];

    //Submit Data To The Server
    final isSuccess = await TodoService.updateTodo(id, body);
    //Show Success Or Fail Message Based On Status
    if (isSuccess) {
      showSuccessMessage(context, message: 'Updation Success');
    } else {
      showSuccessMessage(context, message: 'Updation failed');
    }

  }

  Future<void> submitData() async {
    //Submit Data To The Server
    final isSuccess = await TodoService.addTodo(body);

    //Show Success Or Fail Message Based On Status
    if (isSuccess) {
      titleController.text = '';
      descriptionController.text ='';

    }else{

    }
    }
  Map get body {
    final title =titleController.text;
    final description =descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": true,
    };
  }
  }

