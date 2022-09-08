class Contact {
  String? sId;
  String? firstName;
  String? lastName;
  String? email;
  String? notes;
  String? phone;
  List<String>? picture;

  Contact({this.sId, this.firstName, this.lastName, this.email, this.notes, this.phone, this.picture});

  Contact.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    notes = json['notes'];
    phone = json['phone'];
    picture = json['picture'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['notes'] = notes;
    data['phone'] = phone;
    data['picture'] = picture;
    return data;
  }
}
