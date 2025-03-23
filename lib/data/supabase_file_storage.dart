import 'package:flutter/foundation.dart';
import 'package:random_frame/data/js/js_bridge.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseFileStorage {
  final StorageFileApi _bucket;
  final GoTrueClient _auth;
  final JsBridge _jsBridge;

  SupabaseFileStorage(this._bucket, this._auth, this._jsBridge);

  Future<String> uploadFile(Uint8List image, String name, String username) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      final captchaToken = await _jsBridge.requestCaptchaToken();
      print("captchaToken ===========> $captchaToken");
      final result = await _auth.signInAnonymously(captchaToken: captchaToken);
      if (result.user == null) {
        throw AuthApiException("Auth failed");
      }
    }
    final path = "$username/$name";
    await _bucket.uploadBinary(path, image);
    final publicUrl = _bucket.getPublicUrl(path);
    return publicUrl;
  }
}
