import 'package:flutter/material.dart';
import 'package:number_trivia/presentation/screens/numbertrivia_screen.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

//0xFF   2E   7D   32
//  255  46   128  50
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: resoColor),
      home: NumberTriviaScreen(),
    );
  }
}

final Map<int, Color> colorPalatte = {
  50: Color.fromRGBO(46, 128, 50, 0.1),
  100: Color.fromRGBO(46, 128, 50, 0.2),
  200: Color.fromRGBO(46, 128, 50, 0.3),
  300: Color.fromRGBO(46, 128, 50, 0.4),
  400: Color.fromRGBO(46, 128, 50, 0.5),
  500: Color.fromRGBO(46, 128, 50, 0.6),
  600: Color.fromRGBO(46, 128, 50, 0.7),
  700: Color.fromRGBO(46, 128, 50, 0.8),
  800: Color.fromRGBO(46, 128, 50, 0.9),
  900: Color.fromRGBO(46, 128, 50, 1.0),
};

MaterialColor resoColor = MaterialColor(0xFF2E7D32, colorPalatte);

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: showBottomSheet,
//         // onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ),
//     );
//   }

//   final inputFieldHintStyle = TextStyle(
//     fontFamily: "Roboto",
//     fontWeight: FontWeight.w400,
//     fontSize: 16.0,
//     color: Color.fromRGBO(0, 0, 0, 0.27),
//   );

//   final nickNameStyle = TextStyle(
//     fontFamily: "Roboto",
//     fontSize: 16.0,
//     fontWeight: FontWeight.w500,
//     color: Colors.grey[800],
//     decoration: TextDecoration.none,
//     //letterSpacing: 1.0,
//   );

//   Widget _addBeneForm() {
//     double padding = 0.0;

//     return SingleChildScrollView(
//       child: Container(
//         child: Padding(
//           padding: EdgeInsets.only(top: padding, left: 16.0, right: 16.0),
//           child: Column(
//             children: <Widget>[
//               FixedHeightTextField(
//                 keyboardType: TextInputType.visiblePassword,
//                 onChange: (val) {},
//                 labelNumber: "2",
//                 labelText: "Nick Name",
//                 required: false,
//                 hintText: "Give a nick name to this beneficiary",
//                 hintStyle: inputFieldHintStyle,
//                 text: "nickNameAutoSet",
//                 textStyle: nickNameStyle,
//                 inputFormatters: [
//                   FilteringTextInputFormatter.allow(
//                       RegExp("[a-zA-Z\-\.\(\) ]")),
//                 ],
//               ),
//               SizedBox(height: 16.0),
//               FixedHeightTextField(
//                 labelNumber: "3",
//                 labelText: "Beneficiary Type",
//                 hintText: "",
//                 hintStyle: inputFieldHintStyle,
//                 textStyle: nickNameStyle,
//                 isReadOnly: true,
//                 text: "BKB Account",
//               ),
//               SizedBox(height: 16.0),
//               FixedHeightTextField(
//                 labelNumber: "4",
//                 labelText: "Account Holder Name",
//                 hintText: "",
//                 hintStyle: inputFieldHintStyle,
//                 textStyle: nickNameStyle,
//                 isReadOnly: true,
//                 text: "_accountTitle.accountTitle",
//               ),
//               SizedBox(height: 16.0),
//               Column(
//                 children: [
//                   FixedHeightTextField(
//                     keyboardType: TextInputType.number,
//                     onChange: (v) {},
//                     labelNumber: "5",
//                     labelText: "Mobile Number",
//                     hintText: "Enter Mobile Number",
//                     hintStyle: inputFieldHintStyle,
//                     isReadOnly: true,
//                     textStyle: nickNameStyle,
//                     maxLength: 11,
//                     // text: _accountTitle.mobileNo,
//                     // isReadOnly: _accountTitle.mobileNo != null ? true : false,
//                     text: "_accountTitle.mobileNo",
//                   ),
//                   SizedBox(height: 16.0),
//                 ],
//               ),
//               FixedHeightTextField(
//                 labelNumber: "5",
//                 labelText: "Branch Name",
//                 hintText: "",
//                 hintStyle: inputFieldHintStyle,
//                 textStyle: nickNameStyle,
//                 isReadOnly: true,
//                 text: "_accountTitle.branchName",
//               ),
//               SizedBox(height: 16.0),
//               _btns(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _btns() {
//     final addBeneEvent = () {};
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: <Widget>[
//         FlatButton(
//           onPressed: () {
//             FocusScope.of(context).unfocus();
//             Navigator.of(context).pop();
//           },
//           textColor: Color(0xff498E4C),
//           child: Text(
//             "CANCEL",
//             style: TextStyle(
//                 fontFamily: "Roboto",
//                 fontWeight: FontWeight.w500,
//                 fontSize: 14.0),
//           ),
//         ),
//         SizedBox(
//           width: 24.0,
//         ),
//         //PolyHabitButton("ADD BENEFICIARY", addBeneEvent),
//       ],
//     );
//   }

//   void showBottomSheet() {
//     final double scrHeight = MediaQuery.of(context).size.height;
//     final double viewPaddingTop = MediaQuery.of(context).viewPadding.top;
//     final double generalToolBarHeight = 56.0;
//     final double scrContentPadding = 16.0;
//     final double txtFields = 1.5;
//     final double textFieldsHeight = txtFields * (36.0 + scrContentPadding);
//     print("scrHeight: $scrHeight");
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (_) => KeyboardVisibilityBuilder(
//         builder: (ctx, child, isKeyboardVisible) {
//           final double kbHeight = MediaQuery.of(context).viewInsets.bottom;
//           print("kbHeight: $kbHeight");
//           final double bsHeight = scrHeight -
//               (viewPaddingTop +
//                   generalToolBarHeight +
//                   scrContentPadding +
//                   textFieldsHeight +
//                   kbHeight);
//           return Container(
//             height: bsHeight,
//             color: Colors.white38,
//             child: Align(
//               alignment: Alignment.topCenter,
//               child: _addBeneForm(),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
