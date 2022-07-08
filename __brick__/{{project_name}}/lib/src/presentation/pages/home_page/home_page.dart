import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/core/config/base_config.dart';
import 'package:{{project_name.snakeCase()}}/core/services/translator.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          GetIt.I<BaseConfig>().appName +
              ' - ' +
              GetIt.I<TranslatorService>().translate(
                context,
                'label.pages.home.title',
              ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              GetIt.I<TranslatorService>().translate(
                context,
                'label.pages.home.text',
              ),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: GetIt.I<TranslatorService>().translate(
          context,
          'label.pages.home.increment',
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
