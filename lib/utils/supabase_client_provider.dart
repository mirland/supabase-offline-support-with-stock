import 'package:async/async.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_offline_support_with_stock/utils/config.dart';

class SupabaseClientProvider {
  // Used to call Supabase.initialize only once
  final _clientMemoizer = AsyncMemoizer<SupabaseClient>();

  static final SupabaseClientProvider _instance = SupabaseClientProvider._();

  SupabaseClientProvider._();

  factory SupabaseClientProvider() => _instance;

  Future<SupabaseClient> getClient() async =>
      _clientMemoizer.runOnce(() => Supabase.initialize(
              url: Config.supabaseUrl, anonKey: Config.supabaseAnonKey)
          .then((supabase) => supabase.client));
}
