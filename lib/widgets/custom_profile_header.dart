import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tarea/blocs/blocs.dart';

class CustomProfileHeader extends StatelessWidget {
  final picker = ImagePicker();

  CustomProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final userBloc = context.watch<UserBloc>();
    final user = userBloc.state;
    return SizedBox(
      width: double.infinity,
      height: 120,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            _profileButton(context), 

            const SizedBox(width: 15,),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(user.username, 
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(user.mail)
              ],
            )
          ],
        ),
      ),
    );
  }

  Container _profileButton(BuildContext context) {
    final bloc = context.watch<UserBloc>();

    return Container(
      height: 80,
      width: 80,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            blurStyle: BlurStyle.outer,
            color: Colors.black12
          )
        ]
      ),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        onTap: () {
          _showPictureDialog(context);
        },
        child: Material(
          color: Colors.transparent,
          child: Ink(
            child: _profilePicture(bloc),
          ),
        ),
      ),
    );
  }

  Widget _profilePicture(UserBloc bloc) {
    final path = bloc.state.profileImage;
    const icon = Icon(
      Icons.photo_camera_outlined,
      color: Colors.black54,
    );

    if (path == null) {
      return icon;
    }

    File file = File(path);
    if (file.existsSync()) {
      return Image(image: FileImage(file),);
    } else {
      return icon;
    }
  }

  _showPictureDialog(BuildContext context) {
    showDialog(
      context: context, 
      builder: (context) {
        final userBloc = context.read<UserBloc>();
        return AlertDialog(
          title: const Text("Change profile?",
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              color: Colors.black54
            ),
          ),
          content: const Text("Select an image from"),
          actions: [
            Column(
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        _getImage(userBloc ,option: 1);
                        Navigator.of(context).pop();
                      }, 
                      child: const Text("Remove",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF229799),
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ),
                
                    TextButton(
                      onPressed: () {
                        _getImage(userBloc ,option: 1);
                        Navigator.of(context).pop();
                      }, 
                      child: const Text("Gallery",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF229799),
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ),
                
                    TextButton(
                      onPressed: () {
                        _getImage(userBloc);
                        Navigator.of(context).pop();
                      }, 
                      child: const Text("Camera",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF229799),
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ),
                  ],
                ),

                ElevatedButton(
                  onPressed: () {
                      Navigator.of(context).pop();
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    elevation: 0,
                    shadowColor: Colors.transparent
                  ),
                  child: const SizedBox(
                    width: double.infinity,
                    child: Text("Cancel",
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
          ],
        );
      }
    );
  }

  Future<void> _getImage(UserBloc bloc,{int option = 0}) async {
    XFile? pickedFile;
    if (option == 0) {
      pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    } else {
      pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    }

    if (pickedFile == null) return;

    String? path = await _cut(File(pickedFile.path)); 

    if (path == null || path.isEmpty) return;
    bloc.storeAndUpdate(profileImage: path);
  }

  Future<String?> _cut(File file) async {
    CroppedFile? croppedFile = await ImageCropper().
      cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1)
    );

    if (croppedFile == null) return null;

    return croppedFile.path;
  }
}