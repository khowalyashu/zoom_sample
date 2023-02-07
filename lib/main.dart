import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zoom_native_sdk/zoom_native_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _zoomNativelyPlugin = ZoomNativeSdk();
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.

    try {
      if (!isInitialized) {
        isInitialized = (await _zoomNativelyPlugin.initZoom(
              appKey: "RRMcm3Z7RgBBX76sHfoJEJrqQnlO3n13AHrU",
              appSecret: "Z2kCtZ3qlPDtt2DOnwbf0p8EqSPcydp4PNpk",
            )) ??
            false;
      }
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  String? meetId;
  String? meetPassword;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Zoom Sdk'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                onChanged: (value) {
                  meetId = value;
                },
                decoration: InputDecoration(labelText: 'meet id'),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (value) {
                  meetPassword = value;
                },
                decoration: InputDecoration(labelText: 'Password'),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (meetId == null ||
                      meetPassword == null ||
                      meetId!.isEmpty ||
                      meetPassword!.isNotEmpty) {
                    return;
                  }
                  debugPrint("joinMeting -> isInitialized = $isInitialized");
                  if (isInitialized) {
                    await _zoomNativelyPlugin.joinMeting(
                      meetingNumber: meetId!,
                      meetingPassword: meetPassword!,
                    );
                  }
                },
                child: const Text("join"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
