import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseFileStorage {
  final SupabaseStorageClient _supabase;

  SupabaseFileStorage(this._supabase);

  Future<String> uploadFile(Uint8List image, String name) async {
    try {
      final path = "tmp/$name";
      print("uploadFile | uploading to supabase | $path");
      final urlPath = await _supabase.from('random-results').uploadBinary(
          path, image);
      print("uploadFile | uploaded to supabase | $urlPath");
      final publicUrl = _supabase.from('random-results').getPublicUrl(path);
      print("uploadFile | got public url | $publicUrl");
      return publicUrl;
    } on Exception catch (e) {
      // Anything else that is an exception
      print('Unknown exception: $e');
      throw e;
    } catch (e) {
      // No specified type, handles all
      print('Something really unknown: $e');
      throw e;
    }
  }
}
