import 'package:appwrite/models.dart';

class Employees {
  final String id;
  final String employee;
  final String photo;
  final bool isActive;
  Employees({
    required this.id,
    required this.employee,
    required this.photo,
    required this.isActive,
  });

  factory Employees.formDocument(Document doc) {
    print(doc);
    return Employees(
        id: doc.$id,
        employee: doc.data['name'],
        photo: doc.data['photo'],
        isActive: doc.data['isActive']);
  }
}
