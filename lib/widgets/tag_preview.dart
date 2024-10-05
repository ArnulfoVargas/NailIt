import 'package:flutter/material.dart';

class TagPreview extends StatelessWidget {
  final Color color;
  final String title;
  const TagPreview({super.key, required this.color, this.title = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 225,
      height: 75,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black26,
            blurStyle: BlurStyle.outer,
          )
        ]
      ),
      child: Stack(
        children: [
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
                Text(title,
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
        ],
      ),
    );
  }
}