import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('valid education is posted with authentication', (tester) async {
    Map<String, dynamic>? posted;
    final api = ApiClient(
      baseUrl: 'http://example.test',
      client: MockClient((request) async {
        expect(request.url.path, '/api/v1/education/');
        expect(request.headers['authorization'], 'Token key');
        posted = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(jsonEncode({...posted!, 'id': 'one'}), 201);
      }),
    );
    final auth = AuthState(api, initialToken: 'key');
    addTearDown(api.dispose);
    addTearDown(auth.dispose);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(value: api),
          ChangeNotifierProvider.value(value: auth),
        ],
        child: const MaterialApp(home: EducationFormPage()),
      ),
    );
    await tester.tap(find.text('Simpan'));
    await tester.pump();
    expect(find.text('Kolom ini wajib diisi'), findsNWidgets(2));
    expect(find.text('Tanggal mulai wajib dipilih'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Institusi'),
      'Universitas Indonesia',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Jurusan'),
      'Informatika',
    );
    await tester.tap(find.widgetWithText(TextFormField, 'Tanggal mulai'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Simpan'));
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(posted!['institution'], 'Universitas Indonesia');
    expect(posted!['major'], 'Informatika');
    expect(posted!['started_at'], matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
    expect(find.text('Edukasi berhasil disimpan'), findsOneWidget);
  });
}
