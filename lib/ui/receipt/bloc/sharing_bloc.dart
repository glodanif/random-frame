import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:random_frame/data/js/js_bridge.dart';
import 'package:intl/intl.dart';
import 'package:random_frame/data/supabase_file_storage.dart';
import 'package:random_frame/data/uploaded_files.dart';
import 'package:random_frame/ui/receipt/bloc/sharing_action.dart';

part 'sharing_state.dart';

class SharingBloc extends Cubit<SharingState> {
  final JsBridge _jsBridge;
  final SupabaseFileStorage _fileStorage;
  final UploadedFiles _uploadedFiles;

  SharingBloc(
    this._jsBridge,
    this._fileStorage,
    this._uploadedFiles,
  ) : super(SharingInitial());

  void loadInfo() async {
    emit(LoadingState());
    final packageInfo = await PackageInfo.fromPlatform();
    final context = await _jsBridge.requestContext();
    final date = DateFormat.yMd().format(DateTime.now());
    emit(InfoState(
      appVersion: packageInfo.version,
      username: context.username,
      date: date,
    ));
  }

  Future<void> share(Uint8List image, int uid, SharingAction action) async {
    try {
      final imageUrl = await _uploadFileOfGetExisting(image, uid);
      emit(UploadedState());
      if (action == SharingAction.copy) {
        Clipboard.setData(ClipboardData(text: imageUrl));
      } else if (action == SharingAction.cast) {
        final intentUrl = "https://warpcast.com/~/compose?embeds[]=$imageUrl";
        _jsBridge.openUrl(intentUrl);
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      emit(UploadingFailedState());
    }
  }

  Future<String> _uploadFileOfGetExisting(Uint8List image, int uid) async {
    emit(UploadingState());
    final existingUrl = _uploadedFiles.getUrlById(uid);
    if (existingUrl != null) {
      return existingUrl;
    } else {
      final fileName = _generateRandomFileName();
      final context = await _jsBridge.requestContext();
      final url = await _fileStorage.uploadFile(
        image,
        fileName,
        context.username ?? "anon",
      );
      _uploadedFiles.addFile(uid, url);
      return url;
    }
  }

  String _generateRandomFileName() {
    final random = Random();
    final randomNum = random.nextInt(999999);
    return 'receipt_${DateTime.now().millisecondsSinceEpoch}_$randomNum.png';
  }
}
