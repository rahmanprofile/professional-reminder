import 'dart:developer';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reminder/controller/database_controller.dart';
import 'package:reminder/controller/state_controller.dart';
import 'package:reminder/model/reminder.dart';

class CreateReminder extends StatefulWidget {
  const CreateReminder({super.key});

  @override
  State<CreateReminder> createState() => _CreateReminderState();
}

class _CreateReminderState extends State<CreateReminder> {
  String selectedTime = "08:00 AM";
  String category = "Objective";
  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  String? times;

  Future<void> pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(selectedTime.split(':')[0]), // Extract hour
        minute: int.parse(
            selectedTime.split(':')[1].split(' ')[0]), // Extract minute
      ),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = DateFormat.jm().format(
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            pickedTime.hour,
            pickedTime.minute,
          ),
        );
      });
    }
  }

  List<String> data = [
    "WakeUp",
    "GYM",
    "Breakfast",
    "Meetings",
    "Lunch",
    "QuickNap",
    "Library",
    "Dinner",
    "Sleep",
  ];

  bool __loading = false;
  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.orange[100],
        title: const Text("Create New"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextFormField(
                  maxLines: 1,
                  controller: titleController,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.normal),
                  decoration: const InputDecoration(
                      hintText: "Enter objective",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextFormField(
                  maxLines: 4,
                  controller: subtitleController,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.normal),
                  decoration: const InputDecoration(
                      hintText: "Progress reminder",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: pickTime,
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedTime,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: pickTime,
                        icon: const Icon(Icons.access_time),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    showSelectedItems: true,
                    disabledItemFn: (String s) => s.startsWith('I'),
                  ),
                  items: data,
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      hintText: "country in menu mode",
                      border: InputBorder.none,
                    ),
                  ),
                  onChanged: (value) {
                    category = value.toString();
                  },
                  selectedItem: "Objective",
                ),
              ),
            ),
            const Spacer(),
            __loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : InkWell(
                    onTap: () {
                      setState(() {
                        __loading = true;
                      });
                      Reminder reminder = Reminder(
                        title: titleController.text,
                        subtitle: subtitleController.text,
                        category: category,
                        time: selectedTime.toString(),
                      );
                      context
                          .read<StateController>()
                          .insertData(reminder: reminder)
                          .then((value) {
                        log("data added --> \n${value.id} \n${value.title} \n${value.subtitle} \n${value.category} \n${value.time}");
                        titleController.clear();
                        subtitleController.clear();
                        setState(() {
                          __loading = false;
                          Navigator.pop(context);
                        });
                      }).onError((error, stackTrace) {
                        log("Error --> $error");
                        setState(() {
                          __loading = false;
                        });
                      });
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.orange[100]),
                      child: const Center(
                        child: Text(
                          "Create",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
