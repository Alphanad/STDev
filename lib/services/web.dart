import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stdev/models/contact.dart';

const _baseURL = 'https://contacts-df29.restdb.io/rest/contacts';
const _headers = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
  'x-apikey': '62e3e6d11894fe7edea71921'
};

class Web {
  static Future<List<Contact>> getContacts() async {
    final response = await http.get(
      Uri.parse(_baseURL),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Contact>((json) => Contact.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load contacts.');
    }
  }
}
