import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea/blocs/blocs.dart';
import 'package:tarea/widgets/widgets.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<UserBloc>();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Image(image: AssetImage("images/LogoNailIt.png"), width: 150,),
          const SizedBox(width: double.infinity, height: 200,),
          CustomLoading(
            color: const Color(0xFF229799),
            onLoadFunction: () {
              if (bloc.state.loaded) { 
                Future.delayed(Duration.zero, () {
                  final state = bloc.state;
                  if (state.mail.isEmpty || state.password.isEmpty || state.username.isEmpty || state.phone.isEmpty) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushReplacementNamed("login");
                  } else {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushReplacementNamed("home");
                  }
                });
              }
            },
            thickness: 6,
          )
        ],
      ),
    );
  }
}