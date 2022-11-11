import 'dart:math';

import 'package:datetime_picker_formfield_new/datetime_picker_formfield_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/helper/db_helper.dart';
import 'package:reminder_app/helper/notiftion_helper.dart';
import 'package:reminder_app/models/modls.dart';
import 'package:reminder_app/provider/reminder_provider.dart';
import 'package:timezone/timezone.dart' as tz;

import '../provider/theme_provider.dart';
import '../utils/colors.dart';

DateTime currant = DateTime.now();
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController noteEditingController = TextEditingController();
  TextEditingController timeEditingController = TextEditingController();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();


fetch(){
     Provider.of<ReminderProvider>(context,listen: false).fetchData();
}
  @override
  initState() {
    super.initState();

    init(context);
    fetch();
  }



  DateTime selectedDate = DateTime.now();
  late DateTime fullDate;
  DateTime?  myTime;
  String fulllDate = "";

  Future<DateTime> selectDate(
      {required BuildContext context,
      required id,
      required title,
      required body}) async {
    final date = await showDatePicker(
        context: context,
        firstDate: DateTime(1900),
        initialDate: selectedDate,
        lastDate: DateTime(2100));
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate),
      );
      if (time != null) {
        setState(() {
          fulllDate = DateTimeField.combine(date, time).toString();
          fullDate = DateTimeField.combine(date, time);
        });
        Provider.of<ReminderProvider>(context,listen: false).scheduleNotifications(id: id,title: title,body: body,time: fullDate);
        // scheduleNotifications(id: id, title: title, body: body, time: fullDate);
        // print("==========${fulllDate.split(" ")[1].split(".")[0]}");
      }
      setState(() {
        fulllDate;
      });
      return DateTimeField.combine(date, time);
    } else {
      return selectedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Switch(
                activeColor: Colors.white,
                inactiveThumbColor: Colors.black,
                value: Provider.of<ThemeProvider>(context, listen: false)
                    .isDark,
                onChanged: (val) {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .changTheme();

                }),
                InkWell(
                  onTap: () {

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("New Remindets"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: titleEditingController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Enter Title",
                                labelText: "Title",
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              maxLines: 4,
                              controller: noteEditingController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Enter note",
                                labelText: "Note",
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                selectDate(
                                    context: context,
                                    id:Provider.of<ReminderProvider>(context,listen: false).random,
                                    title: timeEditingController.text,
                                    body: noteEditingController.text
                                );
                              },
                              child: Container(
                                height: 40,
                                width: 140,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue),
                                child: const Center(
                                  child:  Text(
                                          "Select time",
                                          style: TextStyle(color: Colors.white),
                                        )

                                ),
                              ),
                            )
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              await DBHelper.dbHelper.insertData(
                                  title: titleEditingController.text,
                                  subtitle: noteEditingController.text,
                                  time: fulllDate.split(" ")[1].split(".")[0]);

                              Navigator.pop(context);
                              // setState(() {
                              //   dbData = DBHelper.dbHelper.fetchhhhData();
                              // });
                              Provider.of<ReminderProvider>(context,listen: false).fetchData();

                              titleEditingController.clear();
                              noteEditingController.clear();
                              fulllDate = "";
                            },
                            child: const Text("add"),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("cancel"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: (Provider.of<ThemeProvider>(context).isDark)?Colors.white24:const Color(0xfff9a6c2)),
                    child:  Icon(Icons.add, size: 30,color: Theme.of(context).primaryColor),
                  ),
                )
              ],
            ),
            InkWell(
              onTap: (){

              },
              child:  Text(
                "Reminders",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: Provider.of<ReminderProvider>(context).dbData,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    Center(
                      child: Text("${snapshot.error}"),
                    );
                  } else if (snapshot.hasData) {
                    List<Reminders>? allData = snapshot.data;
                    return GridView.builder(
                      itemCount: allData?.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10),
                      itemBuilder: (context, i) => Container(
                        height: 140,
                        width: 160,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:(Provider.of<ThemeProvider>(context).isDark)?alldarkColors[i]:allColors[i]),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${allData?[i].title}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 17,color: Theme.of(context).primaryColor),
                              ),
                              Text(
                                "${allData?[i].subtitle}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Theme.of(context).primaryColor),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      selectDate(
                                              context: context,
                                              id: allData?[i].id,
                                              title: allData?[i].title,
                                              body: allData?[i].subtitle)
                                          .then((value) => DBHelper.dbHelper
                                              .update(
                                                  id: allData![i].id,
                                                  time: fulllDate
                                                      .split(" ")[1]
                                                      .split(".")[0]))
                                          .then((value) =>
                                          Provider.of<ReminderProvider>(context,listen: false).fetchData()

                                      );
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 90,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Theme.of(context).primaryColor),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Center(
                                        child: Text("${allData?[i].time}",style: TextStyle(color: Theme.of(context).primaryColor),),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      selectDate(
                                              context: context,
                                              id: allData?[i].id,
                                              title: allData?[i].title,
                                              body: allData?[i].subtitle)
                                          .then((value) => DBHelper.dbHelper
                                              .update(
                                                  id: allData![i].id,
                                                  time: fulllDate
                                                      .split(" ")[1]
                                                      .split(".")[0]))
                                          .then((value) =>
                                          Provider.of<ReminderProvider>(context,listen: false).fetchData(),

                                      );
                                    },
                                    child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color:Theme.of(context).primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                          child: Icon(Icons.edit,color: Theme.of(context).primaryColor),
                                        )),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      DBHelper.dbHelper
                                          .singlDelet(id: allData?[i].id);

                                      Provider.of<ReminderProvider>(context,listen: false).fetchData();

                                    },
                                    icon: Icon(Icons.delete),
                                    color: Theme.of(context).primaryColor,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
