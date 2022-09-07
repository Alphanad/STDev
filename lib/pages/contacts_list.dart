import 'package:flutter/material.dart';
import 'package:stdev/services/web.dart';
import 'package:stdev/models/contact.dart';
import 'package:stdev/pages/add_contact.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts', style: TextStyle(color: Colors.black),), backgroundColor: Colors.white, elevation: 0,),
      body: Center(
        child: FutureBuilder(
          future: Web.getContacts(),
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
                          onTap: () {},
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddContact()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
