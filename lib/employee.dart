import 'package:employee/user.dart';
import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin

import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({Key? key}) : super(key: key);

  @override
  _BooksearchPageState createState() => _BooksearchPageState();
}

class _BooksearchPageState extends State<EmployeePage> {
  //creation
  // text fields' controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _joiningController = TextEditingController();

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('Employees');

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name of Employee'),
                ),
               
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                   
                  child: const Text('Enter'),
                  onPressed: () async {
                    final String name = _nameController.text;

                    final DateTime joining = DateTime.now();

                    double.tryParse(_joiningController.text);
                    if (name != null) {
                      await _products.add({"name": name, "joining": joining});

                      _nameController.text = '';

                      _joiningController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

 

  
//list of users

  Stream<List<User>> readUsers() => FirebaseFirestore.instance
      .collection('Employees')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());

  // final CollectionReference _products =
  //     FirebaseFirestore.instance.collection('Employees');
  //employee display builder

  Widget buildEmployee(User employee) => ListTile(
        leading: ((DateTime.now().difference(employee.joining).inDays) > 1825)
            ? Icon(Icons.flag_circle_rounded,color: Colors.green,size: 35,)
            : Icon(Icons.flag_circle_outlined,size: 35,),
        title: Text(employee.name),
        subtitle: Text("Joined on : "+employee.joining.toIso8601String().split('T').first),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
             
              IconButton(icon: const Icon(Icons.edit), onPressed: () => {}),
              IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => {}),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Center(child: Center(child: Text('Employees List'))),
        ),
        body: StreamBuilder<List<User>>(
            stream: readUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final employees = snapshot.data!;
                return ListView(
                  children: employees.map(buildEmployee).toList(),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        // Add new product
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () => _create(),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
// Add new product
        );
  }
}
