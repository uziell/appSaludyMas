import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:salud_y_mas/apps/ui/pages/home/home_page.dart';
import 'package:salud_y_mas/apps/ui/pages/request_permission_controller.dart';

class RequestPermissionPage extends StatefulWidget {
  const RequestPermissionPage({Key? key}) : super(key: key);

  @override
  _RequestPermissionPageState createState() => _RequestPermissionPageState();
}

class _RequestPermissionPageState extends State<RequestPermissionPage> {
  final _controller = RequestPermissionController(Permission.location);
  late StreamSubscription _subscription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _subscription = _controller.onStatusChanged.listen((status) {
      if (status == PermissionStatus.granted) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePageGoogle()));
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: ElevatedButton(
            child: Text("Allow"),
            onPressed: () {
              _controller.request();
            },
          ),
        ),
      ),
    );
  }
}
