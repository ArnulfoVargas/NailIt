import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:tarea/blocs/blocs.dart';

import 'package:tarea/models/models.dart';
import 'package:tarea/utils/utils.dart';
import 'package:tarea/widgets/widgets.dart';

class AddToDoPage extends StatefulWidget {
  const AddToDoPage({super.key});

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  Color selectedColor = const Color.fromARGB(255, 244, 67, 54);
  Color tagColor = Colors.red;
  String dateSelectedString = "";
  String tagTitle = "";
  int tagSelected = 0;
  bool edited = false;
  bool nameHasError = false;
  bool descHasError = false;
  bool dateHasError = false;
  bool showPreview = false;
  bool hasTags = false;

  Map<int, TagModel> tags = {};
  DateTime? selectedDate;


  @override
  void initState() {
    super.initState();

    final tagsState = context.read<TagsBloc>();
    tags = tagsState.getTags;
    hasTags = tags.isNotEmpty;
  }

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
        selectedDate = args.toDo!.deadLine;
        tagSelected = args.toDo!.tag;
        dateSelectedString = "${NailUtils.months[selectedDate!.month - 1]} ${selectedDate!.day}, ${selectedDate!.year}";
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
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: _tagsSelector(),
                  ),

                  ColorPicker(
                    onColorChanged: _onColorPickerChange,
                    color: selectedColor,
                    pickerTypeTextStyle: const TextStyle(
                      color: Colors.black38,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                    maxRecentColors: 5,
                    selectedPickerTypeColor: const Color(0xFF229799),
                    pickersEnabled: const {
                      ColorPickerType.customSecondary : false,
                      ColorPickerType.accent : true,
                      ColorPickerType.primary : true,
                      ColorPickerType.custom : false,
                      ColorPickerType.wheel : true,
                      ColorPickerType.both : false,
                      ColorPickerType.bw : false,
                    },
                  ),

                  if (showPreview)
                    ToDoPreview(
                      tagTitle: tagTitle, 
                      toDoColor: selectedColor, 
                      title: title.text, 
                      tagColor: tagColor),

                  Row(
                    children: [
                      Expanded(
                        child: CustomTextButton(
                          text: showPreview ? "Hide preview" : "Show preview", 
                          color: const Color(0xFF229799),
                          onPressed: () {
                            showPreview = !showPreview;
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: CustomTextButton(
                          text: args.isEditing ? "Edit to do" : "Create to do", 
                          color: const Color(0xFF229799),
                          onPressed: dateHasError || descHasError || nameHasError? null : () {
                            _onAppy(args);
                          },
                        ),
                      ),
                    ],
                  ),

                  if (args.isEditing)
                    ElevatedButton(
                      onPressed: () {
                        _showConfirm(args);  
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        elevation: 0,
                        shadowColor: Colors.transparent
                      ),
                      child: const SizedBox(
                        width: double.infinity,
                        child: Text("Delete tag",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    ),
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
                child: Text(dateSelectedString.isEmpty ? "Select a date" : dateSelectedString, 
                  maxLines: 1,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
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
    DateTime? date = await showOmniDateTimePicker(
      context: context,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      type: OmniDateTimePickerType.date,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF229799),
          onPrimary: Colors.white,
          onSurface: Colors.black54,
        )
      ),
    );

    if (date == null && dateSelectedString.isEmpty) {
      dateHasError = true;
    }
    else {
      if (date == null) return;
      dateHasError = false;
      selectedDate = date;
      dateSelectedString = "${NailUtils.months[date.month - 1]} ${date.day}, ${date.year}";
    }
  }

  Widget _tagsSelector() {
    return !hasTags 
    ? Container(
        padding: const EdgeInsets.all(10),
        child: const Center(
          child: Text("You don't have any tags, add some!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black45
            ),
          ),
        ),
      )
    : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ...tags.entries.map(_tagButton)
          ],
        ),
      );
  }

  Widget _tagButton(MapEntry<int, TagModel> entry) {
    final key = entry.key;
    final model = entry.value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        onPressed: () {
          if (tagSelected != key) {
            tagTitle = model.title;
            tagColor = model.color;
            tagSelected = key;
          } else {
            tagTitle = "";
            tagSelected = 0;
          }
          setState(() {});
        }, 
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: tagSelected == key ? model.color : Colors.transparent,
        ),
        child: Text(entry.value.title,
          style: TextStyle(
            color: tagSelected != key ? Colors.black54 : NailUtils.getContrastColor(model.color)
          ),
        )
      ),
    );
  }

  _onColorPickerChange(Color color) {
    selectedColor = color;
    setState(() {});
  }

  _validateTitle(String value) {
    nameHasError = !ToDoModel.isValidToDoName(value);
    setState(() {});
  }

  _validateDescription(String value) {
    descHasError = !ToDoModel.isValidDescription(value);
    setState(() {});
  }
  
  void _onAppy(ToDoArguments args) async {
    nameHasError = !ToDoModel.isValidToDoName(title.text);
    descHasError = !ToDoModel.isValidDescription(description.text);
    dateHasError = selectedDate == null;

    setState(() {});
    if (dateHasError || descHasError || nameHasError) return;

    final bloc = context.read<ToDoBloc>();
    final userBloc = context.read<UserBloc>();
    final toDo = ToDoModel(
      title: title.text, 
      deadLine: selectedDate!,
      toDoColor: selectedColor,
      description: description.text,
      tag: tagSelected,
    );

    Map<String, dynamic> res = <String, dynamic>{};

    NailUtils.showLoading(context);
    if (args.isEditing) {
      res = await bloc.editToDo(args.toDoId, userBloc.state.id, args.toDo!.tag,toDo);
    } else {
      res = await bloc.addToDo(toDo, userBloc.state.id);
    }

    if (res["ok"]) {
      _doPop();
    } else {
      NailUtils.showError(context, res["error"]);
    }

    _doPop();
  }

  _showConfirm(ToDoArguments args) {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure?",
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              color: Colors.black54
            ),
          ),
          content: const Text("This action cannot be reversed"),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          actions: [
            CustomTextButton(
              text: "Cancel", 
              color: Colors.black54,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            ElevatedButton(
              onPressed: () {
                _onDelete(args);
              }, 
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.redAccent,
                shadowColor: Colors.transparent
              ),
              child: const SizedBox(
                child: Text("Delete",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            ),
          ],
        );
      }
    );
  }
  _onDelete(ToDoArguments args) async {
    final bloc = context.read<ToDoBloc>();

    if (args.toDo == null ) return;

    if (args.isEditing) {
      final idUser = context.read<UserBloc>().state.id;

      _doPop();

      NailUtils.showLoading(context);

      final res = await bloc.removeToDo(args.toDoId, idUser, args.toDo!);

      _doPop();

      if (res["ok"]) {
        _doPop();
      } else {
        _doPop();

        NailUtils.showError(context, res["error"]);
      }
    }
  }

  _doPop() {
      Navigator.of(context).pop();
  }
}
