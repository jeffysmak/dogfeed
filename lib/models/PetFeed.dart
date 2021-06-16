class PetFeed {
  String byUserId;
  int when;


  PetFeed(this.byUserId, this.when);

  PetFeed.fromMap(var map) {
    this.byUserId = map['byUser'];
    this.when = map['when'];
    print(when);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['byUser'] = byUserId;
    map['when'] = when;
    return map;
  }
}
