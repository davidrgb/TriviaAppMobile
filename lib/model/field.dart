class Field {
  static const DATA = 'data';
  static const NAME = 'name';
  static const QUESTION = 'question';

  String? docId;
  late List<dynamic> data;
  late String name;
  late String question;

  Field({
    this.docId,
    required List<dynamic> data,
    required this.name,
    required this.question,
  }) {
    this.data = [...data];
  }

  Map<String, dynamic> toFirestoreDoc() {
    return {
      DATA: data,
      NAME: name,
      QUESTION: question,
    };
  }

  static Field? fromFirestoreDoc(
      {required Map<String, dynamic> doc, required String docId}) {
    for (var key in doc.keys) {
      if (doc[key] == null) return null;
    }

    return Field(
      docId: docId,
      data: doc[DATA],
      name: doc[NAME],
      question: doc[QUESTION],
    );
  }
}
