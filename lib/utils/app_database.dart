// database.dart

// required package imports
import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:supabase_offline_support_with_stock/data/project_local_source.dart';
import 'package:supabase_offline_support_with_stock/model/project.dart';

part 'app_database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Project])
abstract class AppDatabase extends FloorDatabase {
  ProjectLocalSource get projectLocalSource;
}
