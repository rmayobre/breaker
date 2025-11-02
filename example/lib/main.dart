import 'package:flutter/material.dart';
import 'package:breaker/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Layout Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Responsive Grid Demo'),
        ),
        body: const ResponsiveLayoutDemo(
          paneOne: Placeholder(color: Colors.blue, strokeWidth: 4),
          paneTwo: Placeholder(color: Colors.red, strokeWidth: 4),
          paneThree: Placeholder(color: Colors.green, strokeWidth: 4),
        ),
      ),
    );
  }
}

final class ResponsiveLayoutDemo extends StatelessWidget {
  const ResponsiveLayoutDemo({
    super.key,
    required this.paneOne,
    required this.paneTwo,
    required this.paneThree,
  });

  final Widget paneOne;
  final Widget paneTwo;
  final Widget paneThree;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
        breakpoints: materialLayoutBreakpoints,
        builder: (context, constraints) {
          if (constraints.axes == 4) {
            return ListLayout(
              constraints: constraints,
              paneOne: paneOne,
              paneTwo: paneTwo,
              paneThree: paneThree,
            );
          } else if (constraints.axes == 8) {
            return ForkedLayout(
              constraints: constraints,
              paneOne: paneOne,
              paneTwo: paneTwo,
              paneThree: paneThree,
            );
          } else {
            return ThreeColumnLayout(
              constraints: constraints,
              paneOne: paneOne,
              paneTwo: paneTwo,
              paneThree: paneThree,
            );
          }
        }
    );
  }
}

final class ListLayout extends StatelessWidget {
  const ListLayout({
    super.key,
    required this.paneOne,
    required this.paneTwo,
    required this.paneThree,
    required this.constraints
  });

  final Widget paneOne;
  final Widget paneTwo;
  final Widget paneThree;

  final LayoutConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutOverlay(
      constraints: constraints,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: constraints.margin),
        child: GridView.builder(
          itemCount: 3,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: constraints.spacing,
            mainAxisSpacing: constraints.spacing,
          ),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return paneOne;
              case 1:
                return paneTwo;
              default:
                return paneThree;
            }
          },
        ),
      ),
    );
  }
}

final class ForkedLayout extends StatelessWidget {
  const ForkedLayout({
    super.key,
    required this.paneOne,
    required this.paneTwo,
    required this.paneThree,
    required this.constraints
  });

  final Widget paneOne;
  final Widget paneTwo;
  final Widget paneThree;

  final LayoutConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final spanSizeTotal = constraints.axisSize * 4;
    final spacingTotal = constraints.spacing * (4 - 1);
    return ResponsiveLayoutOverlay(
      constraints: constraints,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: constraints.margin),
        child: Row(
            children: [
              SizedBox(
                width: spanSizeTotal + spacingTotal,
                child: Column(
                  children: [
                    Flexible(child: paneOne),
                    SizedBox(height: constraints.spacing),
                    Flexible(child: paneTwo),
                  ],
                ),
              ),
              SizedBox(width: constraints.spacing),
              SizedBox(
                width: spanSizeTotal + spacingTotal,
                child: paneThree,
              )
            ]
        ),
      ),
    );
  }
}

final class ThreeColumnLayout extends StatelessWidget {
  const ThreeColumnLayout({
    super.key,
    required this.paneOne,
    required this.paneTwo,
    required this.paneThree,
    required this.constraints
  });

  final Widget paneOne;
  final Widget paneTwo;
  final Widget paneThree;

  final LayoutConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return ResponsiveVerticalLayout(
      debugOverlay: true,
      breakpoints: materialLayoutBreakpoints,
      cells: [
        Cell(
          span: (constraints) => (constraints.axes / 3).toInt(),
          child: paneOne,
        ),
        Cell(
          span: (constraints) => (constraints.axes / 3).toInt(),
          child: paneTwo,
        ),
        Cell(
          span: (constraints) => (constraints.axes / 3).toInt(),
          child: paneThree,
        ),
      ],
    );
  }
}