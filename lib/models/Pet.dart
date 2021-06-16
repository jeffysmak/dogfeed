import 'dart:io';

import 'package:saloon_app/models/PetFeed.dart';

class Pet {
  String id;
  String name;
  String displayPic;
  File petImageFile;
  String docID;
  PetFeed petFeed;
  List<String> users = List.empty(growable: true);

  Pet(this.name, this.petImageFile);

  Pet.fromMap(var map, {this.docID}) {
    this.id = map['id'];
    this.name = map['name'];
    this.displayPic = map['displayPic'];
    // this.petWasFed = map['petWasFed'];
    this.users = List.from(map['users']);
    this.petFeed = map['petWasFed'] != null ? PetFeed.fromMap(map['petWasFed']) : null;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['name'] = name;
    map['displayPic'] = displayPic;
    map['id'] = id;
    map['users'] = users;
    map['petWasFed'] = petFeed != null ? petFeed.toMap() : null;
    return map;
  }
}
