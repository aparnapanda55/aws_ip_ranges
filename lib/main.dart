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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String region;
  late String service;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    region = data.keys.first;
    service = data[region]!.keys.first;
  }

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
              value: region,
              items: data.keys
                  .map(
                    (value) => DropdownMenuItem(
                      child: Text(value),
                      value: value,
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  region = value!;
                  if (!data[region]!.containsKey(service)) {
                    service = data[region]!.keys.first;
                  }
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: DropdownButton<String>(
              value: service,
              items: data[region]!
                  .keys
                  .map(
                    (value) => DropdownMenuItem(
                      child: Text(value),
                      value: value,
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  service = value!;
                });
              },
            ),
          ),
          Expanded(
            flex: 8,
            child: ListView(
              children: data[region]![service]!
                  .map((value) => IpTile(
                        value: value,
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}

class IpTile extends StatelessWidget {
  const IpTile({
    required this.value,
    Key? key,
  }) : super(key: key);
  final String value;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(value),
    );
  }
}
