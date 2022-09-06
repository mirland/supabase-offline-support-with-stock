import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:stock/stock.dart';
import 'package:supabase_offline_support_with_stock/data/project_repository.dart';
import 'package:supabase_offline_support_with_stock/data/project_supabase_remote_source.dart';
import 'package:supabase_offline_support_with_stock/model/project.dart';
import 'package:supabase_offline_support_with_stock/utils/database_provider.dart';
import 'package:supabase_offline_support_with_stock/utils/supabase_client_provider.dart';

// In a real project it should be injected
late ProjectRepository projectRepository;

void main() async {
  final supabaseClient = await SupabaseClientProvider().getClient();
  final databaseClient = await DatabaseProvider().getDataBase();
  final remoteSource = ProjectSupabaseRemoteSource(supabaseClient);
  final localSource = databaseClient.projectLocalSource;
  projectRepository = ProjectRepository(localSource, remoteSource);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xmartlabs',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const OssProjectsPage(),
    );
  }
}

class OssProjectsPage extends StatefulWidget {
  const OssProjectsPage({Key? key}) : super(key: key);

  @override
  State<OssProjectsPage> createState() => _OssProjectsPageState();
}

class _OssProjectsPageState extends State<OssProjectsPage> {
  late StreamSubscription _subscription;

  List<Project>? projects;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _subscription = projectRepository.getProjects().listen((response) {
      print('Store response $response');
      if (response.isData) {
        setState(() {
          projects = response.requireData();
          if (isLoading && response.origin == ResponseOrigin.fetcher) {
            isLoading = false;
          }
        });
      } else if (response.isLoading) {
        setState(() => isLoading = true);
      } else {
        if (isLoading && response.origin == ResponseOrigin.fetcher) {
          setState(() => isLoading = false);
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'An error happened!: ${(response as StockResponseError).error}',
          ),
        ));
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Xmartlabs OSS Projects')),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: projects?.length ?? 0,
            itemBuilder: (context, index) =>
                _ProjectWidget(project: projects![index]),
          ),
          if (isLoading) const CircularProgressIndicator(),
        ],
      ),
    );
  }
}

class _ProjectWidget extends StatelessWidget {
  const _ProjectWidget({Key? key, required this.project}) : super(key: key);

  final Project project;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FlutterWebBrowser.openWebPage(url: project.url),
      child: Card(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 6,
              child: Image(
                image: CachedNetworkImageProvider(project.imageUrl),
                fit: BoxFit.fitHeight,
              ),
            ),
            ListTile(
              title: Text(project.name),
              subtitle: Text(project.description),
            ),
          ],
        ),
      ),
    );
  }
}
