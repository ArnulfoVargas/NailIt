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
  String dateSelected = "";
  bool edited = false;
  bool nameHasError = false;
  bool descHasError = false;
  bool dateHasError = false;

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
        title: Text(args.isEditing ? "Edit to do" : "Create to do"),
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
                    icon: Icons.description,
                    onChanged: _validateDescription,
                    hasError: descHasError,
                    labelText: "Description",
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: _datePickerButton(),
                  )
                ],
              ),
            ),
          )
        )
      )
    );
  }

  Widget _datePickerButton() {
    return Stack(
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                blurStyle: BlurStyle.outer,
                blurRadius: 5,
                color: dateHasError ? Colors.redAccent : Colors.black12
              )
            ]
          ),
        ),
    
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 10),
              child: Icon(Icons.calendar_month, 
                color: dateHasError ? Colors.redAccent : Colors.black45,
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Colors.black12
                    )
                  )
                ),
                child: Text(dateSelected.isEmpty ? "Select a date" : dateSelected, 
                  style: TextStyle(
                    color: dateHasError ? Colors.redAccent : Colors.black38,
                    fontSize: 16,
                  ),
                ),
              )
            ),
            TextButton(
              onPressed: _showDatePicker, 
              style: TextButton.styleFrom(
                elevation: 0,
                maximumSize: const Size(100, 50),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                  )
                )
              ),
              child: const SizedBox(
                height: double.infinity,
                child: Center(
                  child: Text("Select date",
                    style: TextStyle(
                      color: Color(0xFF229799)
                    ),
                  )
                ),
              )
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _showDatePicker() async {
    // DateTime? date = ShowOmni
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
