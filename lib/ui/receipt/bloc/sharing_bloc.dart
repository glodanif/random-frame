import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:random_frame/data/js/js_bridge.dart';
import 'package:intl/intl.dart';
import 'package:random_frame/ui/receipt/bloc/sharing_action.dart';
import 'package:share_plus/share_plus.dart';

part 'sharing_state.dart';

class SharingBloc extends Cubit<SharingState> {
  final JsBridge _jsBridge;

  SharingBloc(this._jsBridge) : super(SharingInitial());

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

  void download(Uint8List image) {
    _jsBridge.downloadImageFromBytes(image, _generateRandomFileName());
  }

  void share(Uint8List image, SharingAction action) {
    final imageUrl = "";
    if (action == SharingAction.share) {
      Share.share(imageUrl);
    } else if (action == SharingAction.copy) {
      Clipboard.setData(ClipboardData(text: imageUrl));
    } else if (action == SharingAction.cast) {
      _jsBridge.openUrl(imageUrl);
    }
  }

  String _generateRandomFileName() {
    final random = Random();
    final randomNum = random.nextInt(999999);
    return 'receipt_${DateTime.now().millisecondsSinceEpoch}_$randomNum.png';
  }
}
