import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

final data = {
  'us-east-1': {
    'EC2': [
      '13.34.37.64/27',
      '3.5.140.0/22',
    ],
    'CODEBUILD': [
      '14.34.37.63/27',
      '30.5.140.3/24',
    ]
  },
  'us-west-2': {
    'EC2': [
      '13.34.37.64/27',
      '3.5.140.0/22',
    ],
    'CODEBUILD': [
      '14.34.37.63/27',
      '30.5.140.3/24',
    ],
    'ROUTE53_RESOLVER': [
      '99.79.20.224/27',
    ]
  }
};

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AWS IP Ranges'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: DropdownButton<String>(
              items: [],
              onChanged: (value) {},
            ),
          ),
          Expanded(
            flex: 1,
            child: DropdownButton<String>(
              items: [],
              onChanged: (value) {},
            ),
          ),
          Expanded(
            flex: 8,
            child: ListView(
              children: [],
            ),
          )
        ],
      ),
    );
  }
}
