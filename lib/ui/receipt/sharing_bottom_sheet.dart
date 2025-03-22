import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:random_frame/domain/game.dart';
import 'package:random_frame/domain/game_result.dart';
import 'package:random_frame/sl/get_it.dart';
import 'package:random_frame/ui/receipt/bloc/sharing_action.dart';
import 'package:random_frame/ui/receipt/bloc/sharing_bloc.dart';
import 'package:random_frame/ui/receipt/receipt.dart';
import 'package:screenshot/screenshot.dart';

class SharingBottomSheet extends StatelessWidget {
  final GameResult result;
  final Game game;
  final String request;
  final _screenshotController = ScreenshotController();

  SharingBottomSheet({
    super.key,
    required this.result,
    required this.game,
    required this.request,
  });

  @override
  Widget build(context) {
    return BlocProvider(
      create: (context) => getIt<SharingBloc>()..loadInfo(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        width: double.infinity,
        child: BlocBuilder<SharingBloc, SharingState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return _loadingView(context);
            } else if (state is InfoState) {
              return _receiptView(
                context: context,
                state: state,
                onDownload: (image) {
                  BlocProvider.of<SharingBloc>(context).download(image);
                },
                onShare: (image, action) {
                  BlocProvider.of<SharingBloc>(context).share(image, action);
                },
                onScreenshotFailed: () {
                  _showMyDialog(context);
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget _loadingView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(36.0),
      child: Center(
        child: SpinKitDoubleBounce(
          size: 64.0,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _receiptView({
    required BuildContext context,
    required InfoState state,
    required Function(Uint8List) onDownload,
    required Function(Uint8List, SharingAction) onShare,
    required Function() onScreenshotFailed,
  }) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Screenshot(
            controller: _screenshotController,
            child: Receipt(
              username: state.username,
              request: request,
              appVersion: state.appVersion,
              result: result,
              date: state.date,
              doneAction: game.doneAction,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton.filled(
                  icon: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SvgPicture.asset(
                      'ic_farcaster.svg',
                      height: 24,
                      width: 24,
                    ),
                  ),
                  onPressed: () async {
                    Uint8List? screenshot = await _captureReceipt();
                    if (screenshot != null) {
                      onShare(screenshot, SharingAction.cast);
                    } else {
                      onScreenshotFailed();
                    }
                  }),
              IconButton.filled(
                  icon: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.share, size: 24),
                  ),
                  onPressed: () async {
                    Uint8List? screenshot = await _captureReceipt();
                    if (screenshot != null) {
                      onShare(screenshot, SharingAction.share);
                    } else {
                      onScreenshotFailed();
                    }
                  }),
              IconButton.filled(
                  icon: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.copy, size: 24),
                  ),
                  onPressed: () async {
                    Uint8List? screenshot = await _captureReceipt();
                    if (screenshot != null) {
                      onShare(screenshot, SharingAction.copy);
                    } else {
                      onScreenshotFailed();
                    }
                  }),
              IconButton.filled(
                icon: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.download, size: 24),
                ),
                onPressed: () async {
                  Uint8List? screenshot = await _captureReceipt();
                  if (screenshot != null) {
                    onDownload(screenshot);
                  } else {
                    onScreenshotFailed();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<Uint8List?> _captureReceipt() async {
    try {
      final Uint8List? imageBytes = await _screenshotController.capture();
      return imageBytes;
    } catch (error) {
      debugPrint('Error capturing receipt: $error');
      return null;
    }
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Unable to generate an image...'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
