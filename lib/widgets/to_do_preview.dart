import 'package:flutter/material.dart';
import 'package:tarea/blocs/blocs.dart';

class ToDoPreview extends StatelessWidget {
  final String title;
  final String? description;
  final Color toDoColor;
  final String tag;
  final TagsBloc tagsBloc;
  const ToDoPreview({super.key, required this.toDoColor, required this.title, this.description, required this.tag, required this.tagsBloc});

  @override
  Widget build(BuildContext context) {
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
        onTap: () {},
        splashColor: Colors.black12,
        highlightColor: Colors.black12.withOpacity(.15),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Stack(
          children: [
            Ink(
              width: double.infinity,
              decoration: BoxDecoration(
                color: toDoColor,
                borderRadius: const BorderRadius.all(Radius.circular(10))
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width * .33 - 10,
              height: 70,
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
                  Text(title,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white
                    ),
                  ),

                  Text(description ?? "",
                    maxLines: 2,
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
                  child: Icon(Icons.edit, color: Colors.black45,),
                ),
              )
            ),

            if (validTag())
              _tagBlock()
          ],
        ),
      ),
    );
  }

  bool validTag() {
    return tag.isNotEmpty && tagsBloc.getTags.containsKey(tag);
  }

  Widget _tagBlock() {
    return Positioned(
      top: 5,
      right: 5,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: tagsBloc.getTags[tag]?.color,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.white, width: 2)
        ),
      )
    );
  }
}