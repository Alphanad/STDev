import 'package:flutter/material.dart';
import 'package:stdev/services/api.dart';
import 'package:stdev/models/contact.dart';
import 'package:stdev/pages/new_contact.dart';
import 'package:stdev/pages/contact_details.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts', style: TextStyle(color: Colors.black),), backgroundColor: Colors.transparent, elevation: 0,),
      body: Center(
        child: FutureBuilder(
          future: API.getContacts(),
          builder: (
              BuildContext context,
              AsyncSnapshot<List<Contact>> snapshot,
              ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text('Error');
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ContactDetails(contact: snapshot.data![index])),
                            );
                          },
                          child: ListTile(
                            leading: snapshot.data![index].picture!.isNotEmpty ?
                            CircleAvatar(
                              backgroundImage: NetworkImage(snapshot.data![index].picture!.first),
                            ) :
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Text(snapshot.data![index].firstName![0], style: const TextStyle(color: Colors.white),),
                            ),
                            title: Text('${snapshot.data![index].firstName} ${snapshot.data![index].lastName}'),
                            subtitle: Text(snapshot.data![index].phone!),
                          ),
                        ),
                        const Divider()
                      ],
                    );
                  },
                );
              } else {
                return const Text('Empty data');
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NewContact()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
