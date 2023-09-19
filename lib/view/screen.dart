import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/controller/controller.dart';
import 'package:reminder/model/models.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  DBController? dbController;
  late Future<List<Models>> noteList;

  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbController = DBController();
    dbController!.initDatabase();
    loadData();
  }

  loadData() async {
    noteList = dbController!.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("SQFLite"),
      ),
      body: FutureBuilder(
        future: context.read<DBController>().getData(),
        builder: (context, AsyncSnapshot<List<Models>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Error: ${snapshot.error ?? 'An unknown error occurred'}"),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final model = snapshot.data![index];
                return ListTile(
                  title: Text(model.title),
                  subtitle: Text(model.body),
                  trailing: IconButton(
                    onPressed: () {
                      context.read<DBController>().deleteData(id: model.id!);
                      noteList = dbController!.getData();
                      snapshot.data!.remove(model.id!);
                    },
                    icon: const Icon(CupertinoIcons.delete),
                  ),
                );
              },
            );
          } else {
            // Handle the case when there is no data.
            return const Center(
              child: Text("No data available."),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Insert"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          hintText: "Enter title",
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: bodyController,
                        decoration: const InputDecoration(
                          hintText: "Enter body",
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        Models models = Models(
                            title: titleController.text,
                            body: bodyController.text);
                        context
                            .read<DBController>()
                            .insertData(models: models)
                            .then((value) {
                          log(" added data --> ${value.title} ${value.body}");
                          titleController.clear();
                          bodyController.clear();
                        });
                      },
                      child: const Text("Insert"),
                    ),
                  ],
                );
              });
        },
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}
