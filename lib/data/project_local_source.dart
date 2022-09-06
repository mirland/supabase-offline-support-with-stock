import 'package:floor/floor.dart';
import 'package:supabase_offline_support_with_stock/model/project.dart';

@dao
abstract class ProjectLocalSource {
  @Query('SELECT * FROM projects')
  Stream<List<Project>> getProjects();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertProjects(List<Project> projects);

  @Query('DELETE FROM projects')
  Future<void> deleteAllProjects();

  @transaction
  Future<void> replaceProjects(List<Project> projects) async {
    await deleteAllProjects();
    await insertProjects(projects);
  }
}
