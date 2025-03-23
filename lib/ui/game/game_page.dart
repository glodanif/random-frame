import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:random_frame/domain/game.dart';
import 'package:random_frame/domain/game_result.dart';
import 'package:random_frame/sl/get_it.dart';
import 'package:random_frame/ui/component/result_renderer.dart';
import 'package:random_frame/ui/game/bloc/game_bloc.dart';
import 'package:random_frame/ui/receipt/sharing_bottom_sheet.dart';

class GamePage extends StatefulWidget {
  final Game _game;

  GamePage({super.key, required gameType}) : _game = Game.getGameById(gameType);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _resultRenderer = ResultRenderer();
  final _requestController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GameBloc>()..initGame(widget._game),
      child: _gameBody(context),
    );
  }

  Widget _gameBody(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          widget._game.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Center(
        child: SizedBox(
          height: double.infinity,
          width: 320.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: TextField(
                  controller: _requestController,
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    hintText: "Type your random request...",
                    hintStyle:
                        TextStyle(color: Color(0x77232446), fontSize: 18),
                    hintTextDirection: TextDirection.ltr,
                  ),
                ),
              ),
              _gameContainer(),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gameContainer() {
    return Flexible(
      child: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          if (state is GameInitial) {
            return _initialView();
          } else if (state is ThinkingState) {
            return _thinkingView();
          } else if (state is ResultState) {
            return _resultView(state.result);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _initialView() {
    return Column(
      children: [
        const AspectRatio(
          aspectRatio: 1,
          child: Text("data"),
        ),
        const SizedBox(height: 18.0),
        Builder(builder: (context) {
          return FilledButton(
            onPressed: () {
              BlocProvider.of<GameBloc>(context).play();
            },
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 64),
            ),
            child: Text(widget._game.action),
          );
        }),
      ],
    );
  }

  Widget _thinkingView() {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: SpinKitFadingFour(
            size: 64.0,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 18.0),
        FilledButton(
          onPressed: null,
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 64),
          ),
          child: Text(widget._game.action),
        ),
      ],
    );
  }

  Widget _resultView(GameResult result) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: _resultRenderer.render(result),
        ),
        const SizedBox(height: 18.0),
        Builder(builder: (context) {
          return Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    BlocProvider.of<GameBloc>(context).play();
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 64),
                  ),
                  child: Text(widget._game.action),
                ),
              ),
              const SizedBox(width: 18.0),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      elevation: 8,
                      isScrollControlled: true,
                      builder: (context) => SharingBottomSheet(
                        result: result,
                        game: widget._game,
                        request: _requestController.text,
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 64),
                  ),
                  child: const Text("Share"),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  @override
  void dispose() {
    _requestController.dispose();
    super.dispose();
  }
}
