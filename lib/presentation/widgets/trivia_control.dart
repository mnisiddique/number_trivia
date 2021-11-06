import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/presentation/bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  @override
  _TriviaControlState createState() {
    return _TriviaControlState();
  }
}

class _TriviaControlState extends State<TriviaControls> {
  final _controller = TextEditingController();
  String _inputStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _textField(),
        SizedBox(height: 10),
        _buttons(),
      ],
    );
  }

  Widget _textField() {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Input a number",
      ),
      onChanged: (value) {
        _inputStr = value;
      },
      onSubmitted: (_) {
        dispatchConcrete();
      },
    );
  }

  Widget _buttons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            child: Text('Search'),
            onPressed: dispatchConcrete,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            child: Text('Get Random Trivia'),
            onPressed: dispatchRandom,
          ),
        ),
      ],
    );
  }

  void dispatchConcrete() {
    _controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(ConcreteNumberTriviaEvent(_inputStr));
    _inputStr = "";
  }

  void dispatchRandom() {
    _controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(RandomNumberTriviaEvent());
  }
}
