import 'package:flutter/material.dart';
import 'package:parasite/parasite.dart';

void main() => runApp(HostProvider(host: CounterHost(), child: const App()));

class CounterHost extends ParasiteHost<int> {
  CounterHost() : super(0);

  void increment() => spread(state + 1);

  void decrement() => spread(state - 1);
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counterHost = HostProvider.of<CounterHost>(context).host;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PARASITE'),
        ),
        body: Parasite(
          host: counterHost,
          builder: (context, value) {
            final counter = value as int;
            return Text('The Value is $counter');
          },
        ),
        floatingActionButton: Align(
          alignment: Alignment.bottomRight,
          child: Column(
            children: [
              FloatingActionButton(
                onPressed: () {
                  counterHost.increment();
                },
                child: const Icon(Icons.add),
              ),
              FloatingActionButton(
                onPressed: () {
                  counterHost.decrement();
                },
                child: const Icon(Icons.remove),
              )
            ],
          ),
        ),
      ),
    );
  }
}
