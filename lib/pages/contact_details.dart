import 'package:flutter/material.dart';
import 'package:stdev/models/contact.dart';
import 'package:stdev/pages/contacts_list.dart';

class ContactDetails extends StatefulWidget {
  const ContactDetails({Key? key, required this.contact}) : super(key: key);

  final Contact contact;

  @override
  State<StatefulWidget> createState() => ContactDetailsState();
}

class ContactDetailsState extends State<ContactDetails> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.contact.firstName!;
    _lastNameController.text = widget.contact.lastName!;
    _phoneController.text = widget.contact.phone!;
    _emailController.text = widget.contact.email!;
    _notesController.text = widget.contact.notes!;
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
          title: const Text('Contact Details', style: TextStyle(color: Colors.black),), iconTheme: const IconThemeData(color: Colors.black,), backgroundColor: Colors.transparent, elevation: 0, centerTitle: true,),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: screenSize.height * 0.03, left: screenSize.width * 0.05, right: screenSize.width * 0.05, bottom: screenSize.height * 0.05),
            child: Column(children: <Widget>[
              widget.contact.picture!.isNotEmpty ? CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.contact.picture!.first),
              ) : CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Text(widget.contact.firstName![0], style: const TextStyle(fontSize: 35, color: Colors.white),),
              ),
              Padding(
                  padding: EdgeInsets.only(top: screenSize.height * 0.05),
                  child: customTextField(_firstNameController, const Icon(Icons.person), 'First name', 1)),
              Padding(
                  padding: EdgeInsets.only(top: screenSize.height * 0.03),
                  child: customTextField(_lastNameController, const Icon(Icons.person), 'Last name', 1)),
              Padding(
                  padding: EdgeInsets.only(top: screenSize.height * 0.03),
                  child: customTextField(_phoneController, const Icon(Icons.phone), 'Phone', 1)),
              Padding(
                  padding: EdgeInsets.only(top: screenSize.height * 0.03),
                  child: customTextField(_emailController, const Icon(Icons.email), 'Email', 1)),
              Padding(
                  padding: EdgeInsets.only(top: screenSize.height * 0.03),
                  child: customTextField(_notesController, const Icon(Icons.email), 'Notes', 5)),
            ]),
          ),
        ),
      ),
    );
  }
}

Widget customTextField(TextEditingController controller, Icon icon, String labelText, int maxLines) {
  return TextFormField(
      enabled: false,
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
          prefixIcon: icon,
          labelText: labelText,
          disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 1),
          )
      )
  );
}
