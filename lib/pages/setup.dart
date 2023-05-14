import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/storage.dart';

import '../widgets/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setup extends StatefulWidget {
  const Setup({super.key});

  @override
  _SetupState createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  // from key
  final _dataFrom = GlobalKey<FormState>();
  // input field controller
  final channelTextController = TextEditingController();
  final fieldTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _changePage();
  }

  // chnage page if data saved
  void _changePage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? status = prefs.getBool(StorageKeys.SAVE_STATUS);
    if (status != null && status) {
      Navigator.pop(context);
      Navigator.pushNamed(context, '/sub');
    }
  }

  // save data and change page
  void _saveData() async {
    if (_dataFrom.currentState!.validate()) {
      if (kDebugMode) {
        print('Valido');
      }

      // save data
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(StorageKeys.CHANNEL_ID, channelTextController.text);
      prefs.setInt(
          StorageKeys.FIELD_COUNT, int.parse(fieldTextController.text));
      prefs.setBool(StorageKeys.SAVE_STATUS, true);

      // change page
      Navigator.pop(context);
      Navigator.pushNamed(context, '/sub');
    } else {
      if (kDebugMode) {
        print('Invalido');
      }
    }
  }

  // void _readData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? v = prefs.getString(StorageKeys.CHANNEL_ID);
  //   print(v);
  //   v = prefs.getString(StorageKeys.FIELD_COUNT);
  //   print(v);
  //   bool? b = prefs.getBool(StorageKeys.SAVE_STATUS);

  //   if (b == null) {
  //     print('bool null');
  //   }
  //   if (b == true) {
  //     print('bool true');
  //   }
  // }

  // void _clearData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   //Remove String
  //   prefs.remove(StorageKeys.CHANNEL_ID);
  //   //Remove bool
  //   prefs.remove(StorageKeys.FIELD_COUNT);
  //   //Remove int
  //   prefs.remove(StorageKeys.SAVE_STATUS);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(
            top: 32.0,
            bottom: 70.0,
            left: 16.0,
            right: 16.0,
          ),
          children: [
            Heading(false),
            SubHeading('Setup'),
            const SizedBox(
              height: 20.0,
            ),
            Form(
              key: _dataFrom,
              child: setForm(),
            )
          ],
        ),
      ),
    );
  }

  // from layout
  Widget setForm() {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, right: 32.0, top: 32.0),
      child: Column(
        children: [
          // channel id
          TextFormField(
            controller: channelTextController,
            decoration: const InputDecoration(
              labelText: 'ID canal ThngSpk(matlab)',
              hintText: 'Poner 1713237',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) return 'No puede estar vacío!';
              if (value.contains(RegExp(r'[A-Z]')) ||
                  value.contains(RegExp(r'[a-z]'))) {
                return 'No puede estar vacío!';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 5.0,
          ),

          // number of field
          TextFormField(
            controller: fieldTextController,
            decoration: const InputDecoration(
              labelText: 'Total de campos',
              hintText: 'Poner 8',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) return 'No puede estar vacío!';
              if (int.parse(value) == 0) return 'No puede estar vacío!';
              if (value.contains(RegExp(r'[A-Z]')) ||
                  value.contains(RegExp(r'[a-z]'))) {
                return 'No puede estar vacío!';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 32.0,
          ),

          // button to save
          ElevatedButton(
            onPressed: _saveData,
            style: TextButton.styleFrom(minimumSize: const Size(100.0, 40.0)),
            child: const Text('Obtener datos del canal'),
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    channelTextController.dispose();
    fieldTextController.dispose();
    super.dispose();
  }
}
