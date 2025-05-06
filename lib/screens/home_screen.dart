import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;
    //final viewModel = Provider.of<HomeVM>(context);

    return const Material(type: MaterialType.transparency, child: Center());
  }
}
