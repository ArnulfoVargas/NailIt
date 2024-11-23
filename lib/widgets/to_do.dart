import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea/blocs/blocs.dart';
import 'package:tarea/models/models.dart';
import 'package:tarea/utils/utils.dart';
import 'package:tarea/widgets/widgets.dart';

class ToDo extends StatelessWidget {
  final ToDoModel toDoModel;
  final TagsBloc tagsBloc;
  final String id;
  const ToDo({super.key, required this.toDoModel, required this.id, required this.tagsBloc});

  @override
  Widget build(BuildContext context) {
    bool isValidTag = _validTag(context);
    String tagTitle = isValidTag ? tagsBloc.getTags[toDoModel.tag]!.title : "";

    return Container(
      width: 50,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black26,
            blurStyle: BlurStyle.outer
          )
        ]
      ),
      child: InkWell(
        onTap: () {
          _showDescription(context);
        },
        splashColor: Colors.black12,
        highlightColor: Colors.black12.withOpacity(.15),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Stack(
          children: [
            Ink(
              width: double.infinity,
              decoration: BoxDecoration(
                color: toDoModel.toDoColor,
                borderRadius: const BorderRadius.all(Radius.circular(10))
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width * .33 - 10,
              height: isValidTag ? 55 : 40,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: const BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(toDoModel.title,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white
                    ),
                  ),

                  if (isValidTag)
                  Text( tagTitle,
                    maxLines: 1,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 12,
                      color: Colors.white60
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: -1,
              right: -1,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                  )
                ),
                child: const Center(
                  child: Icon(Icons.remove_red_eye, color: Colors.black45,),
                ),
              )
            ),

            if (isValidTag)
              _tagBlock()
          ],
        ),
      ),
    );
  }

  void _showDescription(BuildContext context) {
    final date = toDoModel.deadLine;
    final dateFormated = "${NailUtils.months[date.month]} ${date.day}, ${date.year}";
    final containsKey = tagsBloc.getTags.containsKey(toDoModel.tag);

    TagModel? tag = const TagModel(title: "", color: Colors.white);

    if (containsKey) {
      tag = tagsBloc.getTags[toDoModel.tag];
    }

    showDialog(
      barrierDismissible: true,
      context: context, 
      builder: (ctx) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(toDoModel.title,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
                color: Colors.black54
              ),
            ),


            if (containsKey)
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color: tag!.color,
                ),

                child: Text(tag.title,
                  style: TextStyle(
                    color: NailUtils.getContrastColor(tag.color),
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text("Deadline: ", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(dateFormated),
                ],
              ) ,

              if (toDoModel.description != null)
                Text(toDoModel.description ?? ""),
            ],
          ),
        ),

        actions: [
          CustomTextButton(
            text: "Cerrar", 
            color: Colors.redAccent,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),

          CustomTextButton(
            text: "Editar", 
            color: const Color(0xFF229799),
            onPressed: () {
              _pressedEdit(context);
            },
          )
        ],
      )
    );
  }

  void _pressedEdit(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed("add_todo", arguments: ToDoArguments(isEditing: true, toDoId: id, toDo: toDoModel));
  }

  bool _validTag(BuildContext context) {
    final tag = toDoModel.tag;
    final isNotEmpty = tag != 0; 
    final containsKey = tagsBloc.getTags.containsKey(tag);

    if (tag != 0 && !containsKey) {
      toDoModel.tag = 0;
      context.read<ToDoBloc>().editToDo(id, toDoModel);
    }

    return isNotEmpty && containsKey;
  }

  Widget _tagBlock() {
    return Positioned(
      top: 5,
      right: 5,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: tagsBloc.getTags[toDoModel.tag]?.color,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.white, width: 2)
        ),
      )
    );
  }
}