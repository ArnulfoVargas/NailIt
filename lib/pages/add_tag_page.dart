import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea/blocs/blocs.dart';
import 'package:tarea/models/models.dart';
import 'package:tarea/widgets/widgets.dart';

class AddTagPage extends StatefulWidget {
  const AddTagPage({super.key});

  @override
  State<AddTagPage> createState() => _AddTagPageState();
}

class _AddTagPageState extends State<AddTagPage> {
  TextEditingController nameController = TextEditingController();
  bool nameHasErrors = false;
  bool showPreview = false;
  bool edited = false;
  Color selectedColor = const Color.fromARGB(255, 0, 150, 136);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TagArguments args;

    try {
      args = ModalRoute.of(context)?.settings.arguments as TagArguments;
    } catch (err) {
      args = TagArguments();
    }

    if (args.isEditing && !edited) {
      if (args.tag != null) {
        nameController.text = args.tag!.title;
        selectedColor = args.tag!.color;
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
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  CustomInput(
                    controller: nameController,
                    autocorrect: false,
                    hasError: nameHasErrors,
                    errorText: "Must be characters only (3-15)",
                    icon: Icons.label,
                    inputType: TextInputType.text,
                    labelText: "Tag name",
                    onChanged: _onChangeNameInput,
                  ),

                  ColorPicker(
                    onColorChanged: _onColorPickerChange,
                    color: selectedColor,
                    pickerTypeTextStyle: const TextStyle(
                      color: Colors.black38,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
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
                    TagPreview(color: selectedColor, title: nameController.text,),
                  if (showPreview)
                    const SizedBox(height: 10,),

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
                          text: args.isEditing ? "Edit tag" : "Create tag", 
                          color: const Color(0xFF229799),
                          onPressed: nameHasErrors ? null : () {
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
          ),
        )
      ),
    );
  }

  _onChangeNameInput(String value) {
    nameHasErrors = !TagModel.isValidTagName(value);
    setState(() {});
  }

  _onColorPickerChange(Color color) {
    selectedColor = color;
    setState(() {});
  }

  _onAppy(TagArguments args) {
    _onChangeNameInput(nameController.text);
    if (nameHasErrors) return;

    final bloc = context.read<TagsBloc>();
    final id = context.read<UserBloc>().state.id;
    TagModel tag = TagModel(
      title: nameController.text,
      color: selectedColor
    );

    if (args.isEditing) {
      bloc.editTag(args.tagId, id, tag);
    } else {
      bloc.addTag(tag, id);
    }

    Navigator.of(context).pop();
  }

  _onDelete(TagArguments args) {
    final bloc = context.read<TagsBloc>();

    TagModel tag = TagModel(
      title: nameController.text,
      color: selectedColor
    );
    if (args.isEditing) {
      final id = context.read<UserBloc>().state.id;
      bloc.removeTag(args.tagId, id, tag);
      Navigator.of(context).pop();
    }
  }

  _showConfirm(TagArguments args) {
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
                Navigator.of(context).pop();
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
}