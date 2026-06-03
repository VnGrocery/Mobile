import 'package:vngrocery/data/mock_data.dart';

class IdRepository {
  final MockDb _db;

  const IdRepository(this._db);

  String nextId() => _db.nextId();
}
