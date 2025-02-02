import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:expressions/expressions.dart';

void main() {
  // Lock the orientation to portrait mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color lightPurp = Color.fromARGB(255, 203, 207, 238);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(color: const Color.fromARGB(125, 255, 0, 0)),
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            color: lightPurp,
            fontFamily: 'Roboto',
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            color: lightPurp,
            fontFamily: 'Roboto',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            color: lightPurp,
            fontFamily: 'Roboto',
            fontSize: 36,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Center(
          child: Text(
            "Calculator",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
      body: Center(
        child: Calculator(),
      ),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String display = '0';
  bool isNumeric(String s) {
    if (s.isEmpty) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  String eval(String s) {
    // Replace 'x' with '*' for multiplication
    s = s.replaceAll('×', '*');
    s = s.replaceAll("÷", "/");

    // Create an expression from the string
    final expression = Expression.parse(s);

    // Create a context for the evaluation
    final evaluator = const ExpressionEvaluator();

    // Evaluate the expression
    final result = evaluator.eval(expression, {});

    // Return the result as a string
    return result.toString();
  }

  void onButtonPressed(String value) {
    setState(() {
      if (isNumeric(value)) {
        if (display == '0') {
          display = value;
        } else {
          display += value;
        }
      } else if (value == 'AC') {
        display = '0';
      } else if (value == '+/-') {
        if (display[0] == '-') {
          display = display.substring(1);
        } else {
          display = '-$display';
        }
      } else if (value == '%') {
        display = (double.parse(display) / 100).toString();
      } else if (value == '.') {
        if (!display.contains('.')) {
          display += '.';
        }
      } else if (value == '=') {
        display = eval(display).toString();
      } else {
        display += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex:
              1, // Adjust this value to control the space taken by the Display
          child: Display(display: display),
        ),
        Flexible(
          flex:
              3, // Adjust this value to control the space taken by the ButtonGrid
          child: ButtonGrid(onButtonPressed: onButtonPressed),
        ),
      ],
    );
  }
}

class Display extends StatelessWidget {
  const Display({required this.display, super.key});

  final String display;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.centerRight,
      child: Text(
        display,
        style: const TextStyle(fontSize: 48),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class ButtonGrid extends StatelessWidget {
  const ButtonGrid({required this.onButtonPressed, super.key});

  final void Function(String) onButtonPressed;
  static final ButtonStyle fColor = ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(125, 255, 0, 0));
  static final ButtonStyle nColor =
      ElevatedButton.styleFrom(backgroundColor: Colors.grey);

  @override
  Widget build(BuildContext context) {
    TextStyle? acpm = Theme.of(context).textTheme.bodyMedium;
    return Container(
      padding: EdgeInsets.all(10),
      child: GridView.count(
        crossAxisCount: 4,
        childAspectRatio: 1.2,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          CalculatorButton(
            label: 'AC',
            onPressed: onButtonPressed,
            style: fColor,
            text: Text("AC", style: acpm),
          ),
          CalculatorButton(
            label: '+/-',
            onPressed: onButtonPressed,
            style: fColor,
            text: Text("+/-", style: acpm),
          ),
          CalculatorButton(
              label: '%', onPressed: onButtonPressed, style: fColor),
          CalculatorButton(
              label: '÷', onPressed: onButtonPressed, style: fColor),
          CalculatorButton(label: '7', onPressed: onButtonPressed),
          CalculatorButton(label: '8', onPressed: onButtonPressed),
          CalculatorButton(label: '9', onPressed: onButtonPressed),
          CalculatorButton(
              label: '×', onPressed: onButtonPressed, style: fColor),
          CalculatorButton(label: '4', onPressed: onButtonPressed),
          CalculatorButton(label: '5', onPressed: onButtonPressed),
          CalculatorButton(label: '6', onPressed: onButtonPressed),
          CalculatorButton(
              label: '-', onPressed: onButtonPressed, style: fColor),
          CalculatorButton(label: '1', onPressed: onButtonPressed),
          CalculatorButton(label: '2', onPressed: onButtonPressed),
          CalculatorButton(label: '3', onPressed: onButtonPressed),
          CalculatorButton(
              label: '+', onPressed: onButtonPressed, style: fColor),
          SizedBox(),
          CalculatorButton(label: '0', onPressed: onButtonPressed),
          CalculatorButton(label: '.', onPressed: onButtonPressed),
          CalculatorButton(
              label: '=', onPressed: onButtonPressed, style: fColor),
        ],
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  const CalculatorButton(
      {required this.label,
      required this.onPressed,
      super.key,
      this.style,
      this.text});

  final String label;
  final void Function(String) onPressed;
  final ButtonStyle? style;
  final Text? text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: ElevatedButton(
        style: style ??
            ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 78, 78, 78)),
        onPressed: () => onPressed(label),
        child:
            text ?? Text(label, style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
