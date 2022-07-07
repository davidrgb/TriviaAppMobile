class Player {
  static const NAME = 'name';
  static const ID = 'id';
  static const SCORE = 'score';

  late String name;
  late String id;
  late int score;

  Player({
    required this.name,
    required this.id,
    required this.score,
  });

  Map<String, dynamic> toFirestoreDoc() {
    return {
      NAME: name,
      ID: id,
      SCORE: score,
    };
  }

  static Player? fromFirestoreDoc({required Map<String, dynamic> doc}) {
    for (var key in doc.keys) {
      if (doc[key] == null) return null;
    } 

    return Player(
      name: doc[NAME],
      id: doc[ID],
      score: doc[SCORE],
    );
  }
}