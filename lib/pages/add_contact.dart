import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stdev/services/api.dart';
import 'package:stdev/models/contact.dart';
import 'package:stdev/utils/validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stdev/pages/contacts_list.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AddContactState();
}

class AddContactState extends State<AddContact> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();
  bool _buttonEnable = true;
  dynamic imageFile;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onPressDo() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _buttonEnable = false;
      });
      final contact = Contact();
      imageFile != null ? contact.picture = ['https://picsum.photos/200/300'] : contact.picture = [];
      contact.firstName = _firstNameController.text;
      contact.lastName = _lastNameController.text;
      contact.phone = _phoneController.text;
      contact.email = _emailController.text;
      contact.notes = _notesController.text;
      bool response = await API.createContact(contact);
      if(response == true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Contact added!"),
        ));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ContactsList()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Something went wrong!"),
        ));
        setState(() {
          _buttonEnable = true;
        });
      }
    }
  }

  void _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return await Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ContactsList()),
        );
      },
      child: Scaffold(
          appBar: AppBar(leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ContactsList()),
              );
            },
          ),
            title: const Text('Add Contact', style: TextStyle(color: Colors.black),), iconTheme: const IconThemeData(color: Colors.black,), backgroundColor: Colors.transparent, elevation: 0, centerTitle: true,),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.only(top: screenSize.height * 0.03, left: screenSize.width * 0.05, right: screenSize.width * 0.05, bottom: screenSize.height * 0.05),
                child: Column(children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _getFromGallery();
                      },
                    child: imageFile != null ? CircleAvatar(
                      radius: 50,
                      backgroundImage: Image.file(imageFile).image,
                    ) : const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.photo_camera, color: Colors.white,),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: screenSize.height * 0.05),
                      child: customTextField(_firstNameController, TextInputType.name, TextInputAction.next, const Icon(Icons.person), 'First name', false, 1)),
                  Padding(
                      padding: EdgeInsets.only(top: screenSize.height * 0.03),
                      child: customTextField(_lastNameController, TextInputType.name, TextInputAction.next, const Icon(Icons.person), 'Last name', false, 1)),
                  Padding(
                      padding: EdgeInsets.only(top: screenSize.height * 0.03),
                      child: customTextField(_phoneController, TextInputType.phone, TextInputAction.next, const Icon(Icons.phone), 'Phone', false, 1)),
                  Padding(
                      padding: EdgeInsets.only(top: screenSize.height * 0.03),
                      child: customTextField(_emailController, TextInputType.emailAddress, TextInputAction.next, const Icon(Icons.email), 'Email', true, 1)),
                  Padding(
                      padding: EdgeInsets.only(top: screenSize.height * 0.03),
                      child: customTextField(_notesController, TextInputType.text, TextInputAction.done, const Icon(Icons.email), 'Notes', false, 5)),
                ]),
              ),
            ),
          ),
          floatingActionButton: _buttonEnable ? FloatingActionButton(
            onPressed: () {
              _onPressDo();
            },
            child: const Icon(Icons.save),
          ) : FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.grey,
            child: const CircularProgressIndicator(color: Colors.white,),
          ),),
    );
  }
}

Widget customTextField(TextEditingController controller, TextInputType keyboardType, TextInputAction textInputAction, Icon icon, String labelText, bool isEmailValidator, int maxLines) {
  return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      validator: (value) {
        if(!isEmailValidator) {
          return Validators.isTextEmpty(value ?? '');
        } else {
          return Validators.isEmailValid(value ?? '');
        }
      },
      decoration: InputDecoration(
          prefixIcon: icon,
          labelText: labelText,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 1),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.blue),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.red),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.blue),
          )
      )
  );
}
