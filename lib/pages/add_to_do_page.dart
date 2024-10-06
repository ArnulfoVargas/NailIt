import 'package:flutter/material.dart';
import 'package:tarea/models/models.dart';
import 'package:tarea/widgets/widgets.dart';

class AddToDoPage extends StatefulWidget {
  const AddToDoPage({super.key});

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  Color selectedColor = Colors.teal;
  bool edited = false;
  bool nameHasError = false;
  bool descHasError = false;

  @override
  Widget build(BuildContext context) {
    ToDoArguments args;

    try {
      args = ModalRoute.of(context)?.settings.arguments as ToDoArguments;
    } catch (err) {
      args = ToDoArguments();
    }

    if (args.isEditing && !edited) {
      if (args.toDo != null) {
        title.text = args.toDo!.title;
        description.text = args.toDo!.description ?? "";
        selectedColor = args.toDo!.toDoColor;
        edited = true;
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(args.isEditing ? "Edit tag" : "Create tag"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            }, 
            icon: const Icon(Icons.exit_to_app,
              color: Colors.black54,
            )
          )
        ],
      ),
      body: FormKeyboardHidder(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  CustomInput(
                    autocorrect: false,
                    errorText: "Must be characters only (5-15)",
                    icon: Icons.bookmark,
                    controller: title,
                    hasError: nameHasError,
                    inputType: TextInputType.text,
                    labelText: "To do name",
                    onChanged: _validateTitle,
                  ),

                  CustomInput(
                    controller: description,
                    inputType: TextInputType.multiline,
                    autocorrect: false,
                    errorText: "Must be between 0 and 100 characters",
                    onChanged: _validateDescription,
                    hasError: descHasError,
                  )
                ],
              ),
            ),
          )
        )
      )
    );
  }

  _validateTitle(String value) {
    nameHasError = !ToDoModel.isValidToDoName(value);
    setState(() {
    });
  }

  _validateDescription(String value) {
    descHasError = !ToDoModel.isValidDescription(value);
    setState(() {});
  }
}
