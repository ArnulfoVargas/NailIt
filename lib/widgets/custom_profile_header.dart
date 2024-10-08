import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tarea/blocs/blocs.dart';
import 'package:tarea/widgets/widgets.dart';

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

  _showPictureDialog(BuildContext topContext) {
    showDialog(
      context: topContext, 
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
                    CustomTextButton(
                      text: "Remove", 
                      color: const Color(0xFF229799),
                      onPressed: () {
                        _getImage(userBloc, option: 2, context: topContext);
                        Navigator.of(context).pop();
                      }
                    ),               
                    CustomTextButton(
                      text: "Gallery", 
                      color: const Color(0xFF229799),
                      onPressed: () {
                        _getImage( userBloc, option: 1);
                        Navigator.of(context).pop();
                      }
                    ),
                    CustomTextButton(
                      text: "Camera", 
                      color: const Color(0xFF229799),
                      onPressed: () {
                        _getImage(userBloc);
                        Navigator.of(context).pop();
                      }
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

  Future<void> _getImage(UserBloc bloc,{int option = 0, BuildContext? context}) async {
    XFile? pickedFile;
    if (option == 0) {
      pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    } else if (option == 2) {
      if (bloc.state.profileImage == null) return;
      if (bloc.state.profileImage!.isEmpty) return;
      if (context == null) return;
      _showUndo(context ,bloc);
      return;
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

  _showUndo(BuildContext context,UserBloc bloc) {
    String? lastPath = bloc.state.profileImage;
    bloc.storeAndUpdate(profileImage: "");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF229799),
        dismissDirection: DismissDirection.down,
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        elevation: 2,
        // shape: ,
        content: const Text("Undo action?",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        action: SnackBarAction(
          textColor: Colors.white,
          label: "Yes", 
          onPressed: () {
            bloc.storeAndUpdate(profileImage: lastPath);
          }
        ),
      )
    );
  }
}