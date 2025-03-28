import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_frame/domain/game.dart';
import 'package:random_frame/sl/get_it.dart';
import 'package:random_frame/ui/home/bloc/home_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeBloc>()
        ..notifyReady()
        ..loadContext(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is LoadedState) {
            return _homeBody(context, state);
          } else if (state is InvalidLocationState) {
            return _splashWidget();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _splashWidget() {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: SizedBox(
          width: 96.0,
          height: 96.0,
          child: SvgPicture.asset(
            "assets/dice_5.svg",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _homeBody(
    BuildContext context,
    LoadedState state,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hello, ${state.username} 👋",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                BlocProvider.of<HomeBloc>(context).closeFrame();
              },
              icon: const Icon(Icons.close),
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          height: double.infinity,
          width: 256.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Random at your service",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ...Game.getAllGames().map<Widget>(
                (game) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilledButton(
                    onPressed: () {
                      context.push("/game?type=${game.id.name}");
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 64),
                    ),
                    child: Text(
                      "${game.emoji} ${game.callToAction}",
                      style: GoogleFonts.lato(),
                    ),
                  ),
                ),
              ), // Convert to List<Widget>
              Padding(
                padding: const EdgeInsets.only(top: 48.0),
                child: SizedBox(
                  width: 96.0,
                  height: 96.0,
                  child: Transform.rotate(
                      angle: state.randomRotation,
                      child: SvgPicture.asset(
                        "assets/dice_${state.randomDice}.svg",
                        semanticsLabel: 'Random dice',
                        fit: BoxFit.contain,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
