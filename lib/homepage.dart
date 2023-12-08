import 'package:flutter/material.dart';
import 'package:sqlite_crud/db_file.dart';
import 'package:sqlite_crud/notesmodel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DBHelper? dbHelper;
  late Future<List<NotesModel>> notesList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    loadfun();
  }

  loadfun() {
    notesList = dbHelper!.getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SQLite CRUP Operation"),
      ),
      body: FutureBuilder(
          future: notesList,
          builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
            return ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      child: Icon(Icons.delete_forever_outlined),
                    ),
                    onDismissed: (DismissDirection direction) {
                      setState(() {
                        dbHelper!.delete(snapshot.data![index].id);
                        notesList = dbHelper!.getNotesList();
                        snapshot.data!.remove(snapshot.data![index]);
                      });
                    },
                    key: ValueKey(snapshot.data![index].id),
                    child: InkWell(
                      onTap: () {
                        dbHelper!.update(NotesModel(
                            id: snapshot.data![index].id,
                            title: "Second Note",
                            age: 21,
                            description: "Update Data using SQLite in flutter",
                            email: "aassaas"));
                        setState(() {
                          notesList = dbHelper!.getNotesList();
                        });
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(snapshot.data![index].title.toString()),
                          subtitle: Text(
                              snapshot.data![index].description.toString()),
                          trailing: Text(snapshot.data![index].age.toString()),
                        ),
                      ),
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dbHelper!
              .insert(NotesModel(
            title: "First Note",
            age: 25,
            description: "SQLite CRUD Opertation Program ",
            email: "example@mail.com",
          ))
              .then((value) {
            print("Data Added");
            setState(() {
              notesList = dbHelper!.getNotesList();
            });
          }).onError((error, stackTrace) {
            print(error.toString());
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
