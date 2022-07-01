class Question {
  static const ANSWER = 'answer';
  static const CATEGORY = 'category';
  static const FIELDS = 'fields';
  static const INFO = 'info';

  String? docId;
  late String answer;
  late String category;
  late List<dynamic> fields;
  late String info;

  Question({
    this.docId,
    required this.answer,
    required this.category,
    required List<dynamic> fields,
    required this.info,
  }) {
    this.fields = [...fields];
  }

  Map<String, dynamic> toFirestoreDoc() {
    return {
      ANSWER: answer,
      CATEGORY: category,
      FIELDS: fields,
      INFO: info,
    };
  }

  static Question? fromFirestoreDoc(
      {required Map<String, dynamic> doc, required String docId}) {
    for (var key in doc.keys) {
      if (doc[key] == null) return null;
    }

    return Question(
      docId: docId,
      answer: doc[ANSWER],
      category: doc[CATEGORY],
      fields: doc[FIELDS],
      info: doc[INFO],
    );
  }
}
