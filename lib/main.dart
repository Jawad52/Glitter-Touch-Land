import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitter_touch_land/presentation/bloc/glitter_bloc.dart';
import 'package:glitter_touch_land/presentation/pages/glitter_jar_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    BlocProvider(
      create: (context) => GlitterBloc(),
      child: const GlitterApp(),
    ),
  );
}

class GlitterApp extends StatelessWidget {
  const GlitterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glitter Jar',
      theme: ThemeData.dark(),
      home: const GlitterJarPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
