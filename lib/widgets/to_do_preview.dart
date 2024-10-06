import 'package:flutter/material.dart';
class ToDoPreview extends StatelessWidget {
  final String tagTitle;
  final Color toDoColor;
  final String title;
  final Color tagColor;
  const ToDoPreview({super.key, required this.tagTitle, required this.toDoColor, required this.title, required this.tagColor, });

  @override
  Widget build(BuildContext context) {
    bool isValidTag = tagTitle.isNotEmpty;

    return Container(
      width: 160,
      height: 105,
      decoration: BoxDecoration(
        color: toDoColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black26,
            blurStyle: BlurStyle.outer
          )
        ]
      ),
      child: Stack(
        children: [
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
                Text(title,
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
    );
  }

  Widget _tagBlock() {
    return Positioned(
      top: 5,
      right: 5,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: tagColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.white, width: 2)
        ),
      )
    );
  }
}