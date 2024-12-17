import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:employeecard/employees.dart';
import 'package:employeecard/services/appwriteServices.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController _controller = TextEditingController();
  File? image;
  String? photo;
  Uint8List? picture;
  final ImagePicker _picker = ImagePicker();
  late Appwriteservices _appwriteservices;
  List? employees;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _appwriteservices = Appwriteservices();
    employees = [];
    _loadData();
  }

  Future<void> _addEmployee() async {
    if (image != null) {
      final bytes = await image!.readAsBytes();
      final base64img = base64Encode(bytes);
      photo = base64img;
    }
    final name = _controller.text;
    if (name.isNotEmpty) {
      try {
        await _appwriteservices.addEmployee(name, photo!);
        _controller.clear();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _loadData() async {
    try {
      final data = await _appwriteservices.getData();
      setState(() {
        employees = data.map((e) => Employees.formDocument(e)).toList();
      });
      print("===================================");
      print(employees);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _updateActiveStatus(Employees employee) async {
    try {
      final updateStatus = await _appwriteservices.updateActiveStatus(
          employee.id, !employee.isActive);
      setState(() {
        employee.isActive != updateStatus.data['activated'];

        _loadData();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _deleteData(id) async {
    try {
      await _appwriteservices.deleteData(id);
      setState(() {
        _loadData();
      });
    } catch (e) {
      print(e);
    }
  }

  void gallery() async {
    final pickedfile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedfile != null) {
        image = File(pickedfile.path);
        Navigator.pop(context);
      } else {
        print("null");
      }
    });
  }

  void camera() async {
    final pickedfile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedfile != null) {
        image = File(pickedfile.path);
        Navigator.pop(context);
      } else {
        print("null");
      }
    });
  }

  void pickimage() async {
    if (image == null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(244, 255, 255, 255),
              title: Text(
                "Choose a File",
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                TextButton(
                  onPressed: gallery,
                  child: Text(
                    "Gallery",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: camera,
                  child: Text(
                    "Camera",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            );
          });
    } else {
      print("null");
    }
  }

  void addEmployee() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Column(
            children: [
              GestureDetector(
                onTap: pickimage,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey[400],
                  ),
                  child: image != null
                      ? ClipOval(
                          child: Image.file(
                            image!,
                            height: 80,
                            width: 80,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 40,
                        ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[400],
                ),
                child: TextField(
                  controller: _controller,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Employee name",
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[900],
                      foregroundColor: Colors.white,
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      image = null;
                    },
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[900],
                      foregroundColor: Colors.white,
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      _addEmployee();
                      image = null;
                      Navigator.pop(context);
                      _loadData();
                    },
                    child: Text("Save"),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1.8,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                Icons.more_horiz,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/temp");
            },
            icon: Icon(
              Icons.notifications_none,
              size: 28,
            ),
          )
        ],
        title: Text(
          "Employees",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(14),
            itemCount: employees!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2 / 2.5,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onLongPress: () {
                  employees![index].isActive
                      ? null
                      : _deleteData(employees![index].id);
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    // color: const Color.fromARGB(236, 255, 255, 255),
                    color: employees![index].isActive
                        ? Colors.green
                        : Colors.red[600],
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(5, 5),
                        spreadRadius: 0,
                        blurRadius: 5,
                        color: const Color.fromARGB(255, 186, 186, 186),
                      ),
                      BoxShadow(
                        offset: Offset(-5, -5),
                        spreadRadius: 0,
                        blurRadius: 5,
                        color: const Color.fromARGB(255, 206, 206, 206),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        // padding: EdgeInsets.all(10),
                        child: ClipOval(
                          child: Image.memory(
                            picture = base64Decode(employees![index].photo),
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        employees![index].employee,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: employees![index].isActive
                              ? Colors.red[600]
                              : Colors.green[600],
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          _updateActiveStatus(employees![index]);
                        },
                        child: Text(
                          employees![index].isActive
                              ? "Deactivate"
                              : "Activate",
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 226, 243, 226),
        onPressed: addEmployee,
        child: Icon(
          Icons.add,
          color: Colors.green[900],
        ),
      ),
    );
  }
}
