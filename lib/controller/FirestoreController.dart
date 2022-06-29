import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trivia_app/model/constant.dart';
import 'package:trivia_app/model/category.dart';

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
}
