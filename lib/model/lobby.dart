class Lobby {
  static const CATEGORY = 'category';
  static const HOST = 'host';
  static const ID = 'id';
  static const NAME = 'name';
  static const OPEN = 'open';
  static const PLAYERS = 'players';
  static const QUESTIONS = 'questions';
  static const TIMESTAMP = 'timestamp';

  String? docId;
  late String category;
  late String host;
  late String id;
  late String name;
  late bool open;
  late List<dynamic> players;
  late List<dynamic> questions;
  int? timestamp;

  Lobby({
    this.docId,
    required this.category,
    required this.host,
    required this.id,
    required this.name,
    required this.open,
    required List<dynamic> players,
    required List<dynamic> questions,
    this.timestamp,
  }) {
    this.players = [...players];
    this.questions = [...questions];
  }

  void setProperties(Lobby l) {
    this.docId = l.docId;
    this.category = l.category;
    this.host = l.host;
    this.name = l.name;
    this.open = l.open;
    this.players = [...l.players];
    this.questions = [...l.questions];
    this.timestamp = l.timestamp;
  }

  Map<String, dynamic> toFirestoreDoc() {
    return {
      CATEGORY: category,
      HOST: host,
      ID: id,
      NAME: name,
      OPEN: open,
      PLAYERS: players,
      QUESTIONS: questions,
      TIMESTAMP: timestamp,
    };
  }

  static Lobby? fromFirestoreDoc(
      {required Map<String, dynamic> doc, required String docId}) {
        for (var key in doc.keys) {
          if (doc[key] == null) return null;
        }

        return Lobby(
          docId: docId,
          category: doc[CATEGORY],
          host: doc[HOST],
          id: doc[ID],
          name: doc[NAME],
          open: doc[OPEN],
          players: doc[PLAYERS],
          questions: doc[QUESTIONS],
          timestamp: doc[TIMESTAMP],
        );
      }
}
