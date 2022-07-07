import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trivia_app/model/constant.dart';
import 'package:trivia_app/model/category.dart';
import 'package:trivia_app/model/field.dart';
import 'package:trivia_app/model/lobby.dart';
import 'package:trivia_app/model/question.dart';
import 'package:trivia_app/viewscreen/GameScreen.dart';
import 'package:trivia_app/viewscreen/lobby_screen.dart';

class FirestoreController {
  static Future<List<Category>> getCategories() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.CATEGORY_COLLECTION)
        .orderBy(Category.NAME)
        .get();
    var result = <Category>[];
    querySnapshot.docs.forEach((doc) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var c = Category.fromFirestoreDoc(doc: document, docId: doc.id);
        if (c != null) {
          result.add(c);
        }
      }
    });
    return result;
  }

  static Future<List<Question>> getQuestionsFromCategory(
      String category) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.QUESTION_COLLECTION)
        .where(Question.CATEGORY, isEqualTo: category)
        .get();
    var result = <Question>[];
    querySnapshot.docs.forEach((doc) {
      var document = doc.data() as Map<String, dynamic>;
      var q = Question.fromFirestoreDoc(doc: document, docId: doc.id);
      if (q != null) {
        result.add(q);
      }
    });
    return result;
  }

  static Future<Field> getFieldFromDocId(String docId) async {
    var reference = await FirebaseFirestore.instance
        .collection(Constant.FIELD_COLLECTION)
        .doc(docId)
        .get();
    var document = reference.data() as Map<String, dynamic>;
    var f = Field.fromFirestoreDoc(doc: document, docId: docId);
    return f!;
  }

  static Future<String> createLobbyQuestion(Question question) async {
    DocumentReference reference = await FirebaseFirestore.instance
        .collection(Constant.LOBBY_QUESTION_COLLECTION)
        .add(question.toFirestoreDoc());
    return reference.id;
  }

  static Future<String> createLobbyField(Field field) async {
    DocumentReference reference = await FirebaseFirestore.instance
        .collection(Constant.LOBBY_FIELD_COLLECTION)
        .add(field.toFirestoreDoc());
    return reference.id;
  }

  static Future<String> createLobby(Lobby lobby) async {
    DocumentReference reference = await FirebaseFirestore.instance
        .collection(Constant.LOBBY_COLLECTION)
        .add(lobby.toFirestoreDoc());
    return reference.id;
  }

  static Future<List<Lobby>> readLobbies() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.LOBBY_COLLECTION)
        .get();
    var result = <Lobby>[];
    querySnapshot.docs.forEach((doc) {
      var document = doc.data() as Map<String, dynamic>;
      var l = Lobby.fromFirestoreDoc(doc: document, docId: doc.id);
      if (l != null) {
        result.add(l);
      }
    });
    return result;
  }

  static Future<void> updateLobby(
      {required String docId, required Map<String, dynamic> updateInfo}) async {
    await FirebaseFirestore.instance
        .collection(Constant.LOBBY_COLLECTION)
        .doc(docId)
        .update(updateInfo);
  }

  static Future<void> deleteLobby({required String docId}) async {
    await FirebaseFirestore.instance.collection(Constant.LOBBY_COLLECTION).doc(docId).delete();
  }

  static Future<void> listenToLobbyInLobby({required LobbyScreen screen}) async {
    final reference = FirebaseFirestore.instance.collection(Constant.LOBBY_COLLECTION).doc(screen.lobby.docId);
    reference.snapshots().listen((event) {
      var document = event.data() as Map<String, dynamic>;
      print(event.data());
      var l = Lobby.fromFirestoreDoc(doc: document, docId: event.id);
      if (l != null) screen.lobby.setProperties(l);
    });
  }

  static Future<void> listenToLobbyInGame({required GameScreen screen}) async {
    final reference = FirebaseFirestore.instance.collection(Constant.LOBBY_COLLECTION).doc(screen.lobby.docId);
    reference.snapshots().listen((event) {
      var document = event.data() as Map<String, dynamic>;
      print(event.data());
      var l = Lobby.fromFirestoreDoc(doc: document, docId: event.id);
      if (l != null) screen.lobby.setProperties(l);
    });
  }
}
