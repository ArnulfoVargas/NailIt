import 'package:flutter/material.dart';
import 'package:tarea/models/models.dart';

class Tag extends StatelessWidget {
  final int tagId;
  final TagModel tag;
  const Tag({super.key, required this.tag, required this.tagId});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black26,
            blurStyle: BlurStyle.outer,
          )
        ]
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed("add_tag", arguments: TagArguments(isEditing: true, tag: tag, tagId: tagId));
        },
        splashColor: Colors.black12,
        highlightColor: Colors.black12.withOpacity(.15),
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Ink(
              width: double.infinity,
              decoration: BoxDecoration(
                color: tag.color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(30)
                ),
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width * .33 - 10,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tag.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
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
            )
          ],
        ),
      ),
    );
  }
}