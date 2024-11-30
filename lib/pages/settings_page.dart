import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea/blocs/blocs.dart';
import 'package:tarea/utils/utils.dart';
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
              onTap: () {
                Navigator.of(context).pushNamed("premium");
              }
            ),

            _customListTile(
              title: "Delete to do's", 
              icon: Icons.assignment_late_rounded,
              onTap: () async {
                final id = context.read<UserBloc>().state.id;
                NailUtils.showLoading(context);
                final res = await context.read<ToDoBloc>().clearData(id);
                if (res["ok"]) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pop();
                  NailUtils.showError(context, res["error"]);
                }
              }
            ),

            _customListTile(
              title: "Delete tags", 
              icon: Icons.label_off,
              onTap: () async {
                final id = context.read<UserBloc>().state.id;
                NailUtils.showLoading(context);
                final res = await context.read<TagsBloc>().clearData(id);
                if (res["ok"]) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pop();
                  NailUtils.showError(context, res["error"]);
                }
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

  void _logOut(BuildContext context) async {
    context.read<UserBloc>().clearData();
    context.read<CurrentPageBloc>().setCurrentPage(0);
    context.read<ToDoBloc>().emptyToDos();
    context.read<TagsBloc>().emptyTags();
    _pushTo(context, "login");
  }

  void _pushTo(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }

  Future<void> _convertToPremium(UserBloc bloc) async {
    await bloc.convertToPremium();
  }
}