class LobbyQuestion {
  static const ANSWER = 'answer';
  static const CATEGORY = 'category';
  static const FIELDS = 'fields';
  static const NAME = 'name';
  static const DATA = 'data';
  static const INFO = 'info';

  late String answer;
  late String category;
  late List<dynamic> fields;
  late String info;

  LobbyQuestion({
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

  static LobbyQuestion? fromFirestoreDoc({required Map<String, dynamic> doc}) {
    
  }
}