import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarea/blocs/blocs.dart';
import 'package:tarea/controllers/controllers.dart';
import 'package:tarea/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final userCubit = context.read<UserBloc>();
    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                BlocBuilder<UserBloc, UserController>(
                  buildWhen: (prev, curr) => prev != curr,
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _createDataText("User", state.username),
                        _createDataText("Phone", state.phone),
                        _createDataText("Mail", state.mail),
                        _createDataText("Password", state.password),
                      ],
                    );
                  },
                ),
                
                Row(
                  children: [
                    Expanded(
                      child: CustomGradientTextButton(
                        onPressed: () {
                          _closeSesion(context);
                        },
                        text: "Close",
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          fontFamily: "Poppins"
                        ),
                        gradient: const LinearGradient(
                          colors: [
                           Color(0xFFFF416C),
                           Color(0xFFFF4B2B),
                          ]
                        ),
                      )
                    ),

                    const SizedBox(width: 20,),

                    Expanded(
                      child: CustomGradientTextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed("profile_edit");
                        },
                        text: "Edit",
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          fontFamily: "Poppins"
                        ),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF134E5E),
                            Color(0xFF71B280),
                          ]
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ) 
    );
  }

  Future<void> _closeSesion(context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    Navigator.of(context).pushNamedAndRemoveUntil("login", (route) => !route.isActive);
  }

  Widget _createDataText(String key, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: "Poppins",
          color: Colors.black54,
          fontSize: 18,
          fontWeight: FontWeight.bold, 
        ),
        children: [
          TextSpan(text: "$key: "),
          TextSpan(text: value, 
            style: const TextStyle(
              fontWeight: FontWeight.normal
            ) 
          )
        ]
      )
    );
  }
}
