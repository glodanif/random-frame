import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseFileStorage {
  final SupabaseStorageClient _supabase;

  SupabaseFileStorage(this._supabase);

  Future<String> uploadFile(Uint8List image, String name) async {
    final path = "tmp/$name";
    await _supabase.from('random-results').uploadBinary(path, image);
    final publicUrl = _supabase.from('random-results').getPublicUrl(path);
    return publicUrl;
  }
}
