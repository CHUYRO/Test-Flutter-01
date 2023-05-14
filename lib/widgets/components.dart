import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/util/storage.dart';

// Heading widgets
// ignore: must_be_immutable
class Heading extends StatelessWidget {
  late bool logoutButton;
  late BuildContext context;

  Heading(this.logoutButton, {super.key});

  void _clearData() async {
    if (kDebugMode) {
      print('Cerrar sesión presionado!');
    }

    // chnage status
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(StorageKeys.saveStatus, false);

    // back to setup page
    Navigator.pop(context);
    Navigator.pushNamed(context, '/setup');
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        children: [
          const Text(
            'ThingSpeak',
            textScaleFactor: 2.5,
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          logoutButton
              ? Column(
                  children: [
                    IconButton(
                      onPressed: _clearData,
                      icon: const Icon(Icons.logout),
                    ),
                    const Text('Salir'),
                  ],
                )
              : const SizedBox()
        ],
      ),
    );
  }
}

// Sub heading widgets
// ignore: must_be_immutable
class SubHeading extends StatelessWidget {
  String title;
  SubHeading(this.title, {super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 110.0, right: 8.0),
      child: Text(
        title,
        textScaleFactor: 1.8,
        style: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Card widgets
// ignore: must_be_immutable
class CardBuilder extends StatelessWidget {
  IconData logo;
  String heading;
  String state;
  CardBuilder(this.logo, this.heading, this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 10.0,
        child: Column(
          children: [
            ListTile(
              leading: Icon(logo, color: Colors.black),
              title: Text(
                heading,
                textScaleFactor: 1.2,
                style: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(
              indent: 20.0,
              endIndent: 20.0,
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                state,
                textScaleFactor: 4,
                style: TextStyle(color: Colors.blueGrey.shade700),
              ),
            ),
            const SizedBox(
              height: 3,
            )
          ],
        ),
      ),
    );
  }
}
