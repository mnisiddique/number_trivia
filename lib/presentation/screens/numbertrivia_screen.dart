import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/injection_container.dart';
import 'package:number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:number_trivia/presentation/widgets/widgets.dart';

class NumberTriviaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text("Number Trivia")),
          body: SingleChildScrollView(
            child: buildBody(context),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            padding: EdgeInsets.only(top: 55, right: 50),
            child: Banner(
              message: "v - 1.0.0",
              location: BannerLocation.bottomStart,
            ),
          ),
        ),
      ],
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 10.0),
              // Top half
              _topHalf(),
              SizedBox(height: 20),
              // Bottom half
              TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topHalf() {
    return BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case Empty:
            return MessageDisplay(message: "Start searching!");

          case Loading:
            return LoadingWidget();

          case Error:
            return MessageDisplay(message: (state as Error).message);

          case Loaded:
            return TriviaDisplay(numberTrivia: (state as Loaded).numberTivia);

          default:
            return SizedBox();
        }
      },
    );
  }
}
