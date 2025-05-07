
import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  final String args;

  const NotFoundScreen({
    super.key,
    required this.args,
  });

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      body: Center(
        child: Text('No route defined for $args')
      ),
    );
  }
}

