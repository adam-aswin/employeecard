import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class Appwriteservices {
  late Client client;
  late Databases databases;
  static const endpoint = 'https://cloud.appwrite.io/v1';
  static const projectId = '674571fc003ab35a22a6';
  static const databaseId = '6745739f002465f2c5af';
  static const collectionId = '674573c3000eb60a5d85';

  Appwriteservices() {
    client = Client();
    client.setEndpoint(endpoint);
    client.setProject(projectId);
    databases = Databases(client);
  }

  Future<Document> addEmployee(String _employee, String photo) async {
    try {
      final documentId = ID.unique();
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(documentId);
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      final result = await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
        data: {'photo': photo, 'name': _employee, 'isActive': false},
      );
      return result;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Document>> getData() async {
    try {
      final result = await databases.listDocuments(
          databaseId: databaseId, collectionId: collectionId);
      print("-------------------------------------------");
      print(result);
      print("-------------------------------------------");
      return result.documents;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Document> updateActiveStatus(String documentId, bool activated) async {
    try {
      final result = await databases.updateDocument(
          databaseId: databaseId,
          collectionId: collectionId,
          documentId: documentId,
          data: {'isActive': activated});
      return result;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> deleteData(id) async {
    try {
      final result = await databases.deleteDocument(
          databaseId: databaseId, collectionId: collectionId, documentId: id);
    } catch (e) {
      print(e);
    }
  }
}
