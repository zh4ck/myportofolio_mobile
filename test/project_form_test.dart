import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

Future<void> pumpProjectForm(
  WidgetTester tester,
  ApiClient api,
  AuthState auth,
) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        Provider.value(value: api),
        ChangeNotifierProvider.value(value: auth),
      ],
      child: const MaterialApp(home: ProjectFormPage()),
    ),
  );
}

Future<void> enterProjectDetails(WidgetTester tester) async {
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Nama Proyek'),
    'Portfolio',
  );
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Deskripsi Proyek'),
    'My work',
  );
}

Future<void> selectCategory(WidgetTester tester, String label) async {
  final field = find.byType(DropdownButtonFormField<String>);
  await tester.ensureVisible(field);
  await tester.tap(field);
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

Future<void> saveProject(WidgetTester tester) async {
  final button = find.text('Simpan Proyek');
  await tester.ensureVisible(button);
  await tester.tap(button);
  await tester.pumpAndSettle();
}

void main() {
  const categories = {
    'Fotografi': 'photography',
    'Pengembangan Web': 'web-development',
    'Penyuntingan Video': 'video-editing',
    'Grafis Gerak': 'motion-graphics',
    'Desain Grafis': 'graphics-design',
    'Lainnya': 'others',
  };

  for (final category in categories.entries) {
    testWidgets('posts category ${category.value}', (tester) async {
      Map<String, dynamic>? posted;
      final api = ApiClient(
        baseUrl: 'http://example.test',
        client: MockClient((request) async {
          expect(request.url.path, '/api/v1/projects/');
          expect(request.headers['authorization'], 'Token key');
          posted = jsonDecode(request.body) as Map<String, dynamic>;
          return http.Response(jsonEncode({...posted!, 'id': 'one'}), 201);
        }),
      );
      final auth = AuthState(api, initialToken: 'key');
      addTearDown(api.dispose);
      addTearDown(auth.dispose);
      await pumpProjectForm(tester, api, auth);
      await enterProjectDetails(tester);
      await selectCategory(tester, category.key);
      final url = find.widgetWithText(TextFormField, 'Tautan Proyek');
      await tester.ensureVisible(url);
      await tester.enterText(url, 'https://example.com/project');
      await saveProject(tester);
      expect(posted!['tech_stack'], category.value);
      expect(posted!['project_url'], 'https://example.com/project');
      expect(find.text('Proyek berhasil ditambahkan'), findsOneWidget);
    });
  }

  testWidgets('requires a category and a valid project URL', (tester) async {
    var requests = 0;
    final api = ApiClient(
      baseUrl: 'http://example.test',
      client: MockClient((request) async {
        requests++;
        return http.Response('', 500);
      }),
    );
    final auth = AuthState(api, initialToken: 'key');
    addTearDown(api.dispose);
    addTearDown(auth.dispose);
    await pumpProjectForm(tester, api, auth);
    await enterProjectDetails(tester);
    await saveProject(tester);
    expect(find.text('Kolom ini wajib diisi'), findsNWidgets(2));
    expect(requests, 0);

    await selectCategory(tester, 'Pengembangan Web');
    final url = find.widgetWithText(TextFormField, 'Tautan Proyek');
    await tester.ensureVisible(url);
    await tester.enterText(url, 'not-a-url');
    await saveProject(tester);
    expect(
      find.text('Masukkan URL http atau https yang valid'),
      findsOneWidget,
    );
    expect(requests, 0);
  });

  testWidgets('preserves the category and URL after a 401 login', (
    tester,
  ) async {
    final posted = <Map<String, dynamic>>[];
    final api = ApiClient(
      baseUrl: 'http://example.test',
      client: MockClient((request) async {
        if (request.url.path == '/api/v1/auth/logout/') {
          expect(request.headers['authorization'], 'Token expired');
          return http.Response('', 204);
        }
        if (request.url.path == '/api/v1/auth/token/') {
          return http.Response('{"token":"new-key"}', 200);
        }
        expect(request.url.path, '/api/v1/projects/');
        posted.add(jsonDecode(request.body) as Map<String, dynamic>);
        if (posted.length == 1) {
          expect(request.headers['authorization'], 'Token expired');
          return http.Response('', 401);
        }
        expect(request.headers['authorization'], 'Token new-key');
        return http.Response(jsonEncode({...posted.last, 'id': 'one'}), 201);
      }),
    );
    final auth = AuthState(api, initialToken: 'expired');
    addTearDown(api.dispose);
    addTearDown(auth.dispose);
    await pumpProjectForm(tester, api, auth);
    await enterProjectDetails(tester);
    await selectCategory(tester, 'Desain Grafis');
    final url = find.widgetWithText(TextFormField, 'Tautan Proyek');
    await tester.ensureVisible(url);
    await tester.enterText(url, 'https://example.com/project');
    await saveProject(tester);
    expect(find.widgetWithText(TextFormField, 'Nama pengguna'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nama pengguna'),
      'admin',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Kata sandi'),
      'password',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pumpAndSettle();
    expect(find.text('Desain Grafis'), findsOneWidget);
    expect(
      tester.widget<TextFormField>(url).controller!.text,
      'https://example.com/project',
    );
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await saveProject(tester);
    expect(posted, hasLength(2));
    expect(posted[0]['tech_stack'], 'graphics-design');
    expect(posted[1]['tech_stack'], 'graphics-design');
    expect(posted[1]['project_url'], 'https://example.com/project');
    expect(find.text('Proyek berhasil ditambahkan'), findsOneWidget);
  });
}
