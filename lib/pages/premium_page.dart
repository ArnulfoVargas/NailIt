import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea/blocs/blocs.dart';
import 'package:tarea/blocs/pages/page_cubit.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<UserBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Premium"),
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

      floatingActionButton: bloc.state.userType != 1 
        ? FloatingActionButton(
          onPressed: () {
            _convertPremium(bloc);
          },
          backgroundColor: const Color(0xFF229799),
          elevation: 3,
          child: const Icon(Icons.payment,
            color: Colors.white,
            size: 30,
            shadows: [
              Shadow(
                color: Colors.white60,
                blurRadius: 5
              )
            ],
          ),
        ) : null,
      body: SafeArea(
        child: bloc.state.userType == 1 
        ? const Center(
            child: Text("You are a premium user", 
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
          )
        : const SingleChildScrollView(
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: double.infinity,),
              Text("Convert to premium now!", 
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),

              SizedBox(height: 10,),
          
              Text("You could add until 100 tags and notes"),

              SizedBox(height: 50,),

              Text("\$5/Mont", 
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  _convertPremium(UserBloc bloc) async {
    final result = await bloc.convertToPremium();
    if (!result["ok"]) {
      _showError(result["error"]);
      setState(() {});
    }
    else {
      setState(() {});
    }
  }

  _showError(String errorMsg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromARGB(255, 252, 49, 49),
        dismissDirection: DismissDirection.down,
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        content: Text(errorMsg,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      )
    );
  }
}