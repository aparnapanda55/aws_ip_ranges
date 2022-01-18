import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

const url = 'https://ip-ranges.amazonaws.com/ip-ranges.json';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LaunchScreen(),
    );
  }
}

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AWS IP Ranges'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
          child: FutureBuilder<Map<String, Map<String, List<String>>>>(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Text('Error');
              }
              return HomePage(data: snapshot.data!);
            },
          ),
        ),
      ),
    );
  }
}

Future<Map<String, Map<String, List<String>>>> getData() async {
  final res = await http.get(Uri.parse(url));
  final data = jsonDecode(res.body);
  final Map<String, Map<String, List<String>>> result = {};

  for (final item in data['prefixes']) {
    final region = item['region'];
    final service = item['service'];
    if (!result.containsKey(region)) {
      result[region] = {};
    }

    if (!result[region]!.containsKey(service)) {
      result[region]![service] = <String>[];
    }

    result[region]![service]!.add(item['ip_prefix']);
  }
  return result;
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.data}) : super(key: key);

  final Map<String, Map<String, List<String>>> data;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String region;
  late String service;

  @override
  void initState() {
    super.initState();
    region = widget.data.keys.first;
    service = widget.data[region]!.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Region',
                        filled: true,
                        border: InputBorder.none,
                      ),
                      isExpanded: true,
                      value: region,
                      items: widget.data.keys
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
                          if (!widget.data[region]!.containsKey(service)) {
                            service = widget.data[region]!.keys.first;
                          }
                        });
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Region',
                        filled: true,
                        border: InputBorder.none,
                      ),
                      isExpanded: true,
                      value: service,
                      items: widget.data[region]!.keys
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
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text('${widget.data[region]![service]!.length} Results'),
                    IconButton(
                      tooltip: 'Copy all',
                      onPressed: () {},
                      icon: const Icon(
                        Icons.copy,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return IpTile(value: widget.data[region]![service]![index]);
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: widget.data[region]![service]!.length,
              ),
            ),
          ),
        )
      ],
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
      trailing: IconButton(
        icon: const Icon(Icons.copy),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: value)).then(
            (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Copied to clipboard!'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
