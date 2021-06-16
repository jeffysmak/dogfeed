import 'package:flutter/material.dart';

class BusyLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: CircularProgressIndicator(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).primaryColorLight.withOpacity(0.5),
        ),
      ),
    );
  }
}
