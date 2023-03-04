import 'package:flutter/material.dart';

class SamplePage extends StatelessWidget {
  const SamplePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo'),
        centerTitle: true,
        elevation: 4,
        shadowColor: Theme.of(context).shadowColor,
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text('Hello'),
      ),
    );
  }
}
