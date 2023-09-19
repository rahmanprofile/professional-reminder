import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/controller/state_controller.dart';
import 'package:reminder/view/create_reminder.dart';
import '../model/reminder.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.orange[200],
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/img/male.png",
                      height: 50,
                      width: 50,
                    ),
                  ),
                )
              ],
            ),
            const Text(
              "Reminders",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            const Text("Your every updated reminders to continue.",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.black54)),
            const SizedBox(height: 8),
            FutureBuilder<List<Reminder>>(
              future: context.read<StateController>().getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error ?? 'An unknown error occurred'}"),
                  );
                } else if (snapshot.hasData) {
                  return SingleChildScrollView(
                      child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final model = snapshot.data![index];
                          final colorIndex = index % color.length;
                          final newColorIndex = index % colorRoute.length;
                          return box(
                            title: model.title,
                            subtitle: model.subtitle,
                            category: model.category,
                            time: model.time,
                            colors: color[colorIndex],
                            secondColor: colorRoute[newColorIndex],
                            onDelete: () {
                              context
                                  .read<StateController>()
                                  .deleteData(id: model.id!);
                              setState(() {
                                snapshot.data!.remove(model.id!);
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ));
                } else {
                  return const Center(
                    child: Text("No data available."),
                  );
                }
              },
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateReminder()));
        },
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }

  Widget box({
    required String title,
    required String subtitle,
    required String category,
    required String time,
    required Color secondColor,
    required Color colors,
    required VoidCallback onDelete,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 0),
            width: MediaQuery.of(context).size.width * 1.0,
            decoration: BoxDecoration(
              color: colors,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white,
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: secondColor,
                        ),
                        child: Text(
                          time,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: InkWell(
              onTap: onDelete,
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: const Center(
                  child: Icon(CupertinoIcons.delete, size: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} /**/
