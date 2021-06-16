class AppConfig {
  int timeOne;
  int timeTwo;
  int timeThree;

  AppConfig.fromMap(var map) {
    this.timeOne = map['first'];
    this.timeTwo = map['second'];
    this.timeThree = map['third'];
  }
}
