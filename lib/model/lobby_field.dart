class LobbyField {
  static const NAME = 'name';
  static const DATA = 'data';

  late String name;
  late List<dynamic> data;

  LobbyField({
    required this.name,
    required List<dynamic> data,
  }) {
    this.data = [...data];
  }

  Map<String, dynamic> toFirestoreDoc() {
    return {
      NAME: name,
      DATA: data,
    };
  }

  static LobbyField? fromFirestoreDoc({required Map<String, dynamic> doc}) {
    for (var key in doc.keys) {
      if (doc[key] == null) return null;
    }

    return LobbyField(
      name: doc[NAME],
      data: doc[DATA],
    );
  }
}
