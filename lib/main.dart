import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 09',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class StarPainter extends CustomPainter {
  final Color color;

  StarPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    final path = Path();
    final radius = min(size.width, size.height) / 2;
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    const angle = 2 * pi / 5;

    path.moveTo(centerX + radius * cos(0), centerY + radius * sin(0));

    for (int i = 1; i <= 5; i++) {
      double x = centerX + radius * cos(angle * i);
      double y = centerY + radius * sin(angle * i);
      path.lineTo(x, y);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  final random = Random();
  late AnimationController _controller;

  double? _top;
  double? _left;
  Color _color = Colors.deepPurple;
  bool _isRotated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    ); // Repeat the animation indefinitely
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _changePosition(double height, double width, Offset delta) {
    final top = _top == null ? delta.dy : _top! + delta.dy;
    final left = _left == null ? delta.dx : _left! + delta.dx;

    setState(() {
      _top = top;
      _left = left;
    });
  }

  void _changeColor() {
    setState(() {
      _color = Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    });
  }

  void _rotate() {
    setState(() {
      _isRotated = !_isRotated;
      if (_isRotated) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    double width = size.width;
    double height = size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title),
      ),
      body: SizedBox.expand(
        child: Align(
          alignment: Alignment.center,
          child: Stack(
            children: [
              Positioned(
                top: _top,
                bottom: null,
                left: _left,
                right: null,
                child: AnimatedContainer(
                  duration: const Duration(seconds: 2),
                  curve: Curves.linear,
                  child: RotationTransition(
                    turns: _controller,
                    child: Center(
                      child: CustomPaint(
                        painter: StarPainter(_color),
                        size: const Size(200, 200),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    _changeColor();
                  },
                  onLongPress: () {
                    _rotate();
                  },
                  onPanUpdate: (DragUpdateDetails details) {
                    _changePosition(height, width, details.delta);
                  },
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}