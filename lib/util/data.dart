class Data {
  bool status = false;

  // time and date
  String savedDate = '0000-00-00';
  String savedTime = '00:00:00';

  // all data field
  static List<String> keys = [
    'field1',
    'field2',
    'field3',
    'field4',
    'field5',
    'field6',
    'field7',
    'field8'
  ];

  void setLoaded() {
    status = true;
  }

  bool get isloaded {
    return status;
  }

  set date(String date) {
    savedDate = date;
  }

  String get date {
    return savedDate;
  }

  set time(String time) {
    savedTime = time;
  }

  String get time {
    return savedTime;
  }
}
