import 'package:stock/stock.dart';
import 'package:supabase_offline_support_with_stock/data/project_local_source.dart';
import 'package:supabase_offline_support_with_stock/data/project_supabase_remote_source.dart';
import 'package:supabase_offline_support_with_stock/model/project.dart';

class ProjectRepository {
  final Stock<dynamic, List<Project>> _stock;

  ProjectRepository(
    ProjectLocalSource projectLocalSource,
    ProjectSupabaseRemoteSource projectRemoteSource,
  ) : _stock = Stock<dynamic, List<Project>>(
          fetcher: Fetcher.ofStream(
            (_) => projectRemoteSource.getRemoteProjectsStream(),
          ),
          sourceOfTruth: SourceOfTruth<dynamic, List<Project>>(
            reader: (_) => projectLocalSource.getProjects(),
            writer: (_, projects) =>
                projectLocalSource.replaceProjects(projects ?? []),
          ),
        );

  Stream<StockResponse<List<Project>>> getProjects() => _stock.stream(null);
}
