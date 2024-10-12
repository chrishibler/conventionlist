import 'package:convention_list/theme/mocha.dart';
import 'package:convention_list/widgets/clearable_text_field.dart';
import 'package:dio/dio.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/convention.dart';
import '../models/response_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<ResponsePage> f = () async {
    final dio = Dio();
    final response =
        await dio.get('https://api.conventionlist.org/conventions');
    return ResponsePage.fromJson(response.data);
  }();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Image(image: AssetImage('assets/logo-sm.png')),
        ),
        title: const ClearableTextField(hintText: 'Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder(
          future: f,
          builder:
              (BuildContext context, AsyncSnapshot<ResponsePage> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data!.conventions
                    .map<Widget>((c) => getListTile(c))
                    .toList(),
              );
            } else if (snapshot.hasError) {
              return const Text('');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

Widget getListTile(Convention convention) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        convention.name,
        style: const TextStyle(
          fontSize: 18,
          color: CatppuccinMocha.green,
          decoration: TextDecoration.underline,
        ),
      ),
      Text(
        '${DateFormat('dd MMMM yyyy').format(convention.startDate)} - ${DateFormat('dd MMMM yyyy').format(convention.endDate)}',
        style: const TextStyle(
          fontSize: 16,
          fontStyle: FontStyle.italic,
        ),
      ),
      ExpandableText(
        (convention.description ?? '').replaceAll('\n', ' '),
        expandText: 'show more',
        collapseText: 'show less',
        maxLines: 3,
        linkColor: CatppuccinMocha.sapphire,
      ),
      const SizedBox(height: 24),
    ],
  );
}
