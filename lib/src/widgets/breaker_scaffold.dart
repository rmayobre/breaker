import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final class BreakerScaffold extends StatefulWidget {
  const BreakerScaffold({super.key});


  @override
  State<StatefulWidget> createState() => BreakerScaffoldState();
}

final class BreakerScaffoldState extends State<BreakerScaffold> {

  late final scaffoldState = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: throw UnimplementedError(),
      drawer: throw UnimplementedError(),
      body: throw UnimplementedError(),
      floatingActionButton: throw UnimplementedError(),
      bottomNavigationBar: throw UnimplementedError(),
    );
  }


}