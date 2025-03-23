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
  Uint8List? _screenshot;

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
        child: BlocConsumer<SharingBloc, SharingState>(
          listenWhen: (context, state) {
            return state is UploadingFailedState;
          },
          listener: (BuildContext context, SharingState state) {
            if (state is UploadingFailedState) {
              _showMyDialog(context, 'Unable to upload image...');
            }
          },
          buildWhen: (context, state) {
            return state is! UploadingState &&
                state is! UploadedState &&
                state is! UploadingFailedState;
          },
          builder: (context, state) {
            if (state is LoadingState) {
              return _loadingView(context);
            } else if (state is InfoState) {
              return _receiptView(
                context: context,
                state: state,
                onShare: (image, action) {
                  BlocProvider.of<SharingBloc>(context)
                      .share(image, result.hashCode, action);
                },
                onScreenshotFailed: () {
                  _showMyDialog(context, 'Unable to generate an image...');
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
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: SpinKitDoubleBounce(
          size: 24.0,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  Widget _receiptView({
    required BuildContext context,
    required InfoState state,
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
          SizedBox(
            height: 64,
            child: BlocBuilder<SharingBloc, SharingState>(
              buildWhen: (context, state) {
                return state is InfoState ||
                    state is UploadingState ||
                    state is UploadedState;
              },
              builder: (BuildContext context, state) {
                if (state is InfoState || state is UploadedState) {
                  return _sharingButtons(
                    onShare: onShare,
                    onScreenshotFailed: onScreenshotFailed,
                  );
                } else if (state is UploadingState) {
                  return _loadingView(context);
                } else {
                  return Container();
                }
              },
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _sharingButtons({
    required Function(Uint8List, SharingAction) onShare,
    required Function() onScreenshotFailed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton.filled(
            icon: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SvgPicture.asset(
                'assets/ic_farcaster.svg',
                height: 24,
                width: 24,
              ),
            ),
            onPressed: () async {
              Uint8List? screenshot = _screenshot ?? await _captureReceipt();
              if (screenshot != null) {
                _screenshot = screenshot;
                onShare(screenshot, SharingAction.cast);
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
              Uint8List? screenshot = _screenshot ?? await _captureReceipt();
              if (screenshot != null) {
                _screenshot = screenshot;
                onShare(screenshot, SharingAction.copy);
              } else {
                onScreenshotFailed();
              }
            }),
      ],
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

  Future<void> _showMyDialog(BuildContext context, String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
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
