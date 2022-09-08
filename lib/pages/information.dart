import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stdev/services/api.dart';
import 'package:stdev/models/contact.dart';
import 'package:stdev/utils/validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stdev/pages/home.dart';
import 'package:stdev/widgets/custom_textfield.dart';

class Information extends StatefulWidget {
  const Information({Key? key, this.contact}) : super(key: key);

  final Contact? contact;

  @override
  State<StatefulWidget> createState() => InformationState();
}

class InformationState extends State<Information> {
  dynamic imageFile;
  bool _enableEditButton = true;
  bool _enableFloatingButton = true;
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _firstNameController.text = widget.contact!.firstName!;
      _lastNameController.text = widget.contact!.lastName!;
      _phoneController.text = widget.contact!.phone!;
      _emailController.text = widget.contact!.email!;
      _notesController.text = widget.contact!.notes!;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
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

  void _createContact() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _enableFloatingButton = false;
      });
      final contact = Contact();
      imageFile != null ? contact.picture = ['https://picsum.photos/200/300'] : contact.picture = [];
      contact.firstName = _firstNameController.text;
      contact.lastName = _lastNameController.text;
      contact.phone = _phoneController.text;
      contact.email = _emailController.text;
      contact.notes = _notesController.text;
      bool response = await API.createContact(contact);
      if (response == true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Contact added!"),
        ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Something went wrong!"),
        ));
        setState(() {
          _enableFloatingButton = true;
        });
      }
    }
  }

  void _updateContact() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _enableFloatingButton = false;
      });
      final contact = Contact();
      widget.contact!.picture!.isNotEmpty || imageFile != null ? contact.picture = ['https://picsum.photos/200/300'] : contact.picture = [];
      contact.sId = widget.contact!.sId;
      contact.firstName = _firstNameController.text;
      contact.lastName = _lastNameController.text;
      contact.phone = _phoneController.text;
      contact.email = _emailController.text;
      contact.notes = _notesController.text;
      bool response = await API.updateContact(contact);
      if (response == true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Contact updated!"),
        ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Something went wrong!"),
        ));
        setState(() {
          _enableFloatingButton = true;
        });
      }
    }
  }

  void _deleteContact() async {
    setState(() {
      _enableFloatingButton = false;
    });
    bool response = await API.deleteContact(widget.contact!.sId!);
    if (response == true) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Contact deleted!"),
      ));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong!"),
      ));
      setState(() {
        _enableFloatingButton = true;
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
          MaterialPageRoute(builder: (context) => const Home()),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
              );
            },
          ),
          title: Text(
            widget.contact != null
                ? !_enableEditButton
                    ? 'Edit Contact'
                    : 'Contact Details'
                : 'Add Contact',
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            widget.contact != null && _enableEditButton
                ? IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        _enableEditButton = false;
                      });
                    },
                  )
                : const Text(''),
          ],
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.only(top: screenSize.height * 0.03, left: screenSize.width * 0.05, right: screenSize.width * 0.05, bottom: screenSize.height * 0.05),
              child: Column(children: <Widget>[
                widget.contact != null
                    ? widget.contact!.picture!.isNotEmpty
                        ? GestureDetector(
                            onTap: !_enableEditButton
                                ? () {
                                    _getFromGallery();
                                  }
                                : null,
                            child: CircleAvatar(
                              radius: screenSize.width * 0.15,
                              backgroundImage: imageFile != null ? Image.file(imageFile).image : NetworkImage(widget.contact!.picture!.first),
                            ),
                          )
                        : GestureDetector(
                            onTap: !_enableEditButton
                                ? () {
                                    _getFromGallery();
                                  }
                                : null,
                            child: CircleAvatar(
                              radius: screenSize.width * 0.15,
                              backgroundImage: imageFile != null ? Image.file(imageFile).image : null,
                              backgroundColor: imageFile != null ? null : Colors.grey,
                              child: imageFile != null
                                  ? null
                                  : !_enableEditButton
                                      ? const Icon(
                                          Icons.photo_camera,
                                          color: Colors.white,
                                        )
                                      : Text(
                                          widget.contact!.firstName![0],
                                          style: const TextStyle(fontSize: 35, color: Colors.white),
                                        ),
                            ),
                          )
                    : GestureDetector(
                        onTap: () {
                          _getFromGallery();
                        },
                        child: CircleAvatar(
                          radius: screenSize.width * 0.15,
                          backgroundImage: imageFile != null ? Image.file(imageFile).image : null,
                          backgroundColor: imageFile != null ? null : Colors.grey,
                          child: imageFile != null
                              ? null
                              : const Icon(
                                  Icons.photo_camera,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                Padding(padding: EdgeInsets.only(top: screenSize.height * 0.05), child: CustomTextField(enable: widget.contact != null && _enableEditButton ? false : true, controller: _firstNameController, keyboardType: TextInputType.name, textInputAction: TextInputAction.next, prefixIcon: const Icon(Icons.person), labelText: 'First name', isEmailValidator: false, maxLines: 1)),
                Padding(padding: EdgeInsets.only(top: screenSize.height * 0.03), child: CustomTextField(enable: widget.contact != null && _enableEditButton ? false : true, controller: _lastNameController, keyboardType: TextInputType.name, textInputAction: TextInputAction.next, prefixIcon: const Icon(Icons.person), labelText: 'Last name', isEmailValidator: false, maxLines: 1)),
                Padding(padding: EdgeInsets.only(top: screenSize.height * 0.03), child: CustomTextField(enable: widget.contact != null && _enableEditButton ? false : true, controller: _phoneController, keyboardType: TextInputType.phone, textInputAction: TextInputAction.next, prefixIcon: const Icon(Icons.phone), labelText: 'Phone', isEmailValidator: false, maxLines: 1)),
                Padding(padding: EdgeInsets.only(top: screenSize.height * 0.03), child: CustomTextField(enable: widget.contact != null && _enableEditButton ? false : true, controller: _emailController, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, prefixIcon: const Icon(Icons.email), labelText: 'Email', isEmailValidator: true, maxLines: 1)),
                Padding(padding: EdgeInsets.only(top: screenSize.height * 0.03), child: CustomTextField(enable: widget.contact != null && _enableEditButton ? false : true, controller: _notesController, keyboardType: TextInputType.text, textInputAction: TextInputAction.done, prefixIcon: const Icon(Icons.email), labelText: 'Notes', isEmailValidator: false, maxLines: 5)),
              ]),
            ),
          ),
        ),
        floatingActionButton: widget.contact != null
            ? !_enableEditButton
                ? FloatingActionButton(
                    onPressed: _enableFloatingButton
                        ? () {
                            _updateContact();
                          }
                        : () {},
                    backgroundColor: _enableFloatingButton ? null : Colors.grey,
                    child: _enableFloatingButton
                        ? const Icon(Icons.save)
                        : const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                  )
                : FloatingActionButton(
                    onPressed: _enableFloatingButton
                        ? () {
                            _deleteContact();
                          }
                        : () {},
                    backgroundColor: _enableFloatingButton ? Colors.red : Colors.grey,
                    child: _enableFloatingButton
                        ? const Icon(Icons.delete)
                        : const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                  )
            : FloatingActionButton(
                onPressed: _enableFloatingButton
                    ? () {
                        _createContact();
                      }
                    : () {},
                backgroundColor: _enableFloatingButton ? null : Colors.grey,
                child: _enableFloatingButton
                    ? const Icon(Icons.save)
                    : const CircularProgressIndicator(
                        color: Colors.white,
                      ),
              ),
      ),
    );
  }
}

Widget customTextField(bool enable, TextEditingController controller, TextInputType keyboardType, TextInputAction textInputAction, Icon icon, String labelText, bool isEmailValidator, int maxLines) {
  return TextFormField(
      enabled: enable,
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      validator: (value) {
        if (!isEmailValidator) {
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
          ),
          disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 1),
          )));
}
