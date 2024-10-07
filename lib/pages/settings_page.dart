import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea/blocs/blocs.dart';
import 'package:tarea/widgets/widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
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
      body: SingleChildScrollView(
        child: Column(
          children: [

            CustomProfileHeader(),

            _customListTile(
              title: "Profile", 
              icon: Icons.person,
              onTap: () {
                _pushTo(context, "profile");
              }
            ),
            _customListTile(
              title: "Pro", 
              icon: Icons.monetization_on,
              onTap: null
            ),

            _customListTile(
              title: "Delete to do's", 
              icon: Icons.assignment_late_rounded,
              onTap: () async {
                await context.read<ToDoBloc>().clearData();
              }
            ),

            _customListTile(
              title: "Delete tags", 
              icon: Icons.label_off,
              onTap: () async {
                await context.read<TagsBloc>().clearData();
              }
            ),

            _customListTile(
              title: "Log out", 
              icon: Icons.exit_to_app,
              textColor: Colors.redAccent,
              iconsColor: Colors.redAccent,
              onTap: () {
                _logOut(context);
              }
            )
          ],
        ),
      ),
    );
  }

  Widget _customListTile({required String title, required IconData icon, Color textColor = Colors.black54, Color iconsColor = Colors.black38, void Function()? onTap}) {
    return ListTile(
      title: Text(title, 
        style: TextStyle(
          fontSize: 18,
          color: textColor,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios_outlined, color: iconsColor, size: 20,),
      leading: Icon(icon, color: iconsColor,),
      tileColor: onTap == null ? Colors.black12 : Colors.transparent,
      onTap: onTap,
    );
  }

  Future<void> _logOut(BuildContext context) async {
    await context.read<UserBloc>().clearData();
    await context.read<ToDoBloc>().clearData();
    await context.read<TagsBloc>().clearData();

    context.read<CurrentPageBloc>().setCurrentPage(0);
    _pushTo(context, "login");
  }

  void _pushTo(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }
}