//docId
//fields
//name
//questions

class Category {
  static const FIELDS = 'fields';
  static const NAME = 'name';
  static const QUESTIONS = 'questions';

  String? docId;
  late List<dynamic> fields;
  late String name;
  late List<dynamic> questions;

  Category({
    this.docId,
    required List<dynamic> fields,
    required this.name,
    required List<dynamic> questions,
  }) {
    this.fields = [...fields];
    this.questions = [...questions];
  }

  static Category? fromFirestoreDoc(
      {required Map<String, dynamic> doc, required String docId}) {
    for (var key in doc.keys) {
      if (doc[key] == null) return null;
    }

    return Category(
      docId: docId,
      fields: doc[FIELDS],
      name: doc[NAME],
      questions: doc[QUESTIONS],
    );
  }
}
