class AppUser {
  String id;
  String email;
  String password;
  String petID;
  String userName;

  AppUser(this.userName, this.email, this.password);

  AppUser.empty();

  AppUser.fromMap(var map, String id) {
    this.id = id;
    this.email = map['email'];
    this.password = map['password'];
    this.petID = map['dogId'];
    this.userName = map['userName'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['email'] = email;
    map['password'] = password;
    map['dogId'] = petID;
    map['userName'] = userName;
    return map;
  }
}
