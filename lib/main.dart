import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({this.apiClient, super.key});

  final ApiClient? apiClient;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        if (apiClient == null)
          Provider<ApiClient>(
            create: (_) => ApiClient(),
            dispose: (_, client) => client.dispose(),
          )
        else
          Provider<ApiClient>.value(value: apiClient!),
        ChangeNotifierProvider(
          create: (context) => AuthState(context.read<ApiClient>()),
        ),
      ],
      child: MaterialApp(
        title: 'MyPortfolio Mobile',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: MyHomePage(),
      ),
    );
  }
}
