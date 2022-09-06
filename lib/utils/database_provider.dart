import 'package:async/async.dart';

import 'app_database.dart';

class DatabaseProvider {
  // Used to call Supabase.initialize only once
  final _clientMemoizer = AsyncMemoizer<AppDatabase>();

  static final DatabaseProvider _instance = DatabaseProvider._();

  DatabaseProvider._();

  factory DatabaseProvider() => _instance;

  Future<AppDatabase> getDataBase() => _clientMemoizer.runOnce(
      () => $FloorAppDatabase.databaseBuilder('app_database.db').build());
}
