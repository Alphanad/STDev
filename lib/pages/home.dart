import 'package:flutter/material.dart';
import 'package:stdev/pages/login.dart';
import 'package:stdev/services/api.dart';
import 'package:stdev/models/contact.dart';
import 'package:stdev/configs/strings.dart';
import 'package:stdev/pages/information.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onLogout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(Strings.contacts, style: TextStyle(color: Colors.black)),
        leading: IconButton(icon: const Icon(Icons.menu, color: Colors.black), onPressed: () => _scaffoldKey.currentState?.openDrawer()),
      ),
      body: Center(
        child: FutureBuilder(
          future: API.getContacts(),
          builder: (BuildContext context, AsyncSnapshot<List<Contact>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text(Strings.error);
              } else if (snapshot.hasData) {
                return snapshot.data!.isNotEmpty
                    ? ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Information(contact: snapshot.data![index]))),
                                child: ListTile(
                                  subtitle: Text(snapshot.data![index].phone!),
                                  title: Text('${snapshot.data![index].firstName} ${snapshot.data![index].lastName}'),
                                  leading: snapshot.data![index].picture!.isNotEmpty ? CircleAvatar(backgroundImage: NetworkImage(snapshot.data![index].picture!.first)) : CircleAvatar(backgroundColor: Colors.grey, child: Text(snapshot.data![index].firstName![0], style: const TextStyle(color: Colors.white))),
                                ),
                              ),
                              const Divider()
                            ],
                          );
                        },
                      )
                    : const Text(Strings.noContacts);
              } else {
                return const Text(Strings.empty);
              }
            } else {
              return Text('${Strings.state}: ${snapshot.connectionState}');
            }
          },
        ),
      ),
      drawer: Drawer(
        child: Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () => _onLogout(),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, textStyle: const TextStyle(fontSize: 20), padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1, vertical: screenSize.height * 0.03)),
            child: const Text(Strings.logout),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Information())),
      ),
    );
  }
}
