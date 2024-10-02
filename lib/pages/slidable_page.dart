import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea/blocs/pages/page_cubit.dart';
import 'package:tarea/external/FluidNavBar/fluid_bottom_nav_bar.dart';
import 'package:tarea/external/FluidNavBar/fluid_nav_bar.dart';
import 'package:tarea/pages/pages.dart';

class SlidablePage extends StatefulWidget {
  const SlidablePage({super.key});

  @override
  State<SlidablePage> createState() => _SlidablePageState();
}

class _SlidablePageState extends State<SlidablePage> {
  PageController controller = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bottom = _bottomNavBar();

    return Scaffold(
      bottomNavigationBar: bottom,
      body: PageView(
        onPageChanged: (value) {
          context.read<CurrentPageBloc>().setCurrentPage(value);
        },
        controller: controller,
        children: const [
          HomePage(),
          ProfileEditPage()
        ],
      ),
    );
  }

  FluidNavBar _bottomNavBar() {
    return FluidNavBar(
      defaultIndex: currentIndex,
      icons: [
        FluidNavBarIcon(icon: Icons.home),
        FluidNavBarIcon(icon: Icons.settings)
      ], 
      currentIndex: currentIndex,
      animationFactor: .25,
      style: const FluidNavBarStyle(
        iconSelectedForegroundColor: Color(0xFF2C3E50),
        iconUnselectedForegroundColor: Colors.black26,
      ),
      onChange: (value) => controller.animateToPage(value, duration: const Duration(milliseconds: 250), curve: Curves.easeIn),
    );
  }
}