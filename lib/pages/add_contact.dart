import 'package:flutter/material.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(iconTheme: const IconThemeData(color: Colors.black,), backgroundColor: Colors.transparent, elevation: 0),
      body: const Center(
        child: Text(
          'Add Contact!'
        ),
      ),
    );
  }
}
