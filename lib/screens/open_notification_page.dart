import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class OpenNotificationPage extends StatefulWidget {
  static const String routeName = '/OpenNotificationPage';

  final String? payload;

  const OpenNotificationPage({
    Key? key,
    this.payload,
  }) : super(key: key);

  @override
  State<OpenNotificationPage> createState() => _OpenNotificationPageState();
}

class _OpenNotificationPageState extends State<OpenNotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: const [],
      ),
    );
  }
}
