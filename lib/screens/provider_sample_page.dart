import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/user.dart';

class ProviderSamplePage extends StatefulWidget {
  static const String routeName = '/ProviderSamplePage';

  const ProviderSamplePage({Key? key}) : super(key: key);

  @override
  State<ProviderSamplePage> createState() => _ProviderSamplePageState();
}

class _ProviderSamplePageState extends State<ProviderSamplePage> {
  @override
  Widget build(BuildContext context) {
    final providerUser = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Sample'),
      ),
      body: Column(
        children: [
          Text(
            'User Information ${providerUser.name} ',
            style: const TextStyle(fontSize: 24),
          ),
          ElevatedButton(
              onPressed: () {
                providerUser.name = 'Weincoders';
              },
              child: const Text(
                'update info user',
                style: TextStyle(fontSize: 24),
              ))
        ],
      ),
    );
  }
}
