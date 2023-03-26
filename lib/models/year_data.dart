class YearData {
  late final int year;
  late final int id;
  late final int uid;
  late final List<String> months;

  YearData(
      {required this.id,
      required this.uid,
      required this.year,
      required this.months});

  factory YearData.fromJson(Map<String, dynamic> json) {
    return YearData(
        id: int.parse(json['id']),
        uid: int.parse(json['uid']),
        year: int.parse(json['year']),
        months: [
          json['jan'],
          json['feb'],
          json['mar'],
          json['apr'],
          json['may'],
          json['jun'],
          json['jul'],
          json['aug'],
          json['sep'],
          json['oct'],
          json['nov'],
          json['dec'],
        ]);
  }
}
