import 'package:flutter/material.dart';
import 'package:flutter_template/widgets/common_widgets.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.backAppBar("主页"),
      body: const Center(
        child: Text("这是主页面"),
      ),
    );
  }
}
