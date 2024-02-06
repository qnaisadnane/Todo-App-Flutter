import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TodoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateEdit;
  final Function(String) deleteById;
  const TodoCard({
    super.key,
     required this.index,
     required this.item,
    required this.navigateEdit,
    required this.deleteById,
  });


  @override
  Widget build(BuildContext context) {
    final id = item['_id'] as String;
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text('${index +1}',
          style: GoogleFonts.notoSans(
              textStyle: const TextStyle(fontSize: 15)
          ),
        ),
        ),
        title: Text(item['title'],
          style: GoogleFonts.notoSans(
              textStyle: const TextStyle(fontSize: 15)
          ),),
        subtitle: Text(item['description'],
          style: GoogleFonts.notoSans(
              textStyle: const TextStyle(fontSize: 15)
          ),),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if(value == 'edit') {
              // Open Edit Page
              navigateEdit(item);
            }else if(value == 'delete'){
              // Delete and remove the item
              deleteById(id);
            }
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text('Edit',
                  style: GoogleFonts.notoSans(
                      textStyle: const TextStyle(fontSize: 15)
                  ),
                ),
                value: 'edit',
              ),
              PopupMenuItem(
                child: Text('Delete',
                  style: GoogleFonts.notoSans(
                      textStyle: const TextStyle(fontSize: 15)
                  ),
                ),
                value: 'delete',
              ),
            ];
          },
        ),
      ),
    );

  }
}
