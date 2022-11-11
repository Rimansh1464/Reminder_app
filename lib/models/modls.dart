import 'dart:convert';

List<Reminders> postDataModelFromJson(String str) =>
    List<Reminders>.from(json.decode(str).map((x) => Reminders.fromJson(x)));

class Reminders {


  final int id;
  final String title;
  final String subtitle;
  final String time;

  Reminders({required this.id, required this.title, required this.subtitle,required this.time});

  factory Reminders.fromJson(Map<String, dynamic> json) =>
      Reminders(id: json["id"], title: json["title"], subtitle: json["subtitle"],time:json["time"]);
}
