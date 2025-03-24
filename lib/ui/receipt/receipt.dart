
import 'package:flutter/material.dart';
import 'package:random_frame/app_theme.dart';
import 'package:random_frame/domain/game_result.dart';
import 'package:random_frame/ui/component/dotted_line_divider.dart';
import 'package:random_frame/ui/component/result_renderer.dart';

class Receipt extends StatefulWidget {
  final String? username;
  final String request;
  final String appVersion;
  final String date;
  final String doneAction;
  final GameResult result;

  const Receipt({
    super.key,
    required this.username,
    required this.request,
    required this.appVersion,
    required this.result,
    required this.date,
    required this.doneAction,
  });

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  final _renderer = ResultRenderer();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: gradientBackgroundEnd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Random receipt",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  widget.date,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 8.0),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      TextSpan(
                        text: "@${widget.username ?? "guest"} ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: widget.doneAction),
                    ],
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  "Request: ${widget.request}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          DottedLineDivider(color: Theme.of(context).colorScheme.secondary),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: _renderer.render(widget.result),
          ),
          DottedLineDivider(color: Theme.of(context).colorScheme.secondary),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Issuer: Random by @glodanif",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  "v${widget.appVersion}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
