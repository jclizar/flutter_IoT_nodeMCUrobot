class PublishItem {
  int value;
  bool? sendStatus;
  DateTime? created;

  String getName() {
    switch (this.value) {
      case 1:
        return "Standby";
      case 2:
        return "Forward";
      case 3:
        return "Backward";
      case 4:
        return "Left shift";
      case 5:
        return "Right shift";
      case 6:
        return "Turn left";
      case 7:
        return "Turn Right";
      case 8:
        return "Lie";
      case 9:
        return "Say Hi";
      case 10:
        return "Fighting";
      case 11:
        return "Push up";
      case 12:
        return "Sleep";
      case 13:
        return "Dance1";
      case 14:
        return "Dance2";
      case 15:
        return "Dance3";
      default:
        throw new Exception("No value named");
    }
  }

  void setSendStatus(bool status) {
    this.sendStatus = status;
  }

  PublishItem(this.value, {this.created, this.sendStatus}) {
    if (this.created == null) {
      this.created = DateTime.now();
    }
  }
}
