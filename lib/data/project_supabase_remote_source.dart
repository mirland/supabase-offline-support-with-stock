import 'package:supabase/supabase.dart';
import 'package:supabase_offline_support_with_stock/model/project.dart';

class ProjectSupabaseRemoteSource {
  final SupabaseClient _client;

  ProjectSupabaseRemoteSource(this._client);

  Stream<List<Project>> getRemoteProjectsStream() => _client
      .from('projects')
      .stream(['id'])
      .execute()
      .map((json) => json.map(Project.fromJson).toList());
}
