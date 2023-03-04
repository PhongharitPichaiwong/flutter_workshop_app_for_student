import 'package:flutter/material.dart';
import 'package:google_mao/provider/cat.dart';
import 'package:google_mao/screens/home_screen.dart';
import 'package:provider/provider.dart';

import '../provider/user.dart';
import 'notification_page.dart';
import 'sameple_page.dart';

class ProviderSamplePage extends StatefulWidget {
  static const String routeName = '/ProviderSamplePage';

  const ProviderSamplePage({Key? key}) : super(key: key);

  @override
  State<ProviderSamplePage> createState() => _ProviderSamplePageState();
}

class _ProviderSamplePageState extends State<ProviderSamplePage> {
  @override
  Widget build(BuildContext context) {
    // final providerUser = Provider.of<UserProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          Consumer<CatProvider>(builder: (context, instance, child) {
            return ElevatedButton(
                onPressed: () {
                  // instance.name = 'Yoda';

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SamplePage()),
                  );
                },
                child: Text(
                  'Cat name: ${instance.name}',
                  style: const TextStyle(fontSize: 24),
                ));
          })
          // Text(
          //   'User Information ${providerUser.name} ',
          //   style: const TextStyle(fontSize: 24),
          // ),
          // ElevatedButton(
          //     onPressed: () {
          //       providerUser.name = 'Weincoders';
          //     },
          //     child: const Text(
          //       'update info user',
          //       style: TextStyle(fontSize: 24),
          //     ))
        ],
      ),
    );
  }
}
