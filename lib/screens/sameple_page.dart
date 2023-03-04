import 'package:flutter/material.dart';

class SamplePage extends StatefulWidget {
  final String payload;

  const SamplePage({super.key, required this.payload});

  @override
  State<SamplePage> createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  late String name1;

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> init() async {
    name1 = "Goodbye";
  }

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
      body: Column(
        children: [
          Center(
            child: Text(widget.payload),
          ),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    name1 = "See you again!";
                  });
                },
                child: Center(child: Text(name1))),
          )
        ],
      ),
    );
  }
}
