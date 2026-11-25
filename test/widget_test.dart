import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  testWidgets('public project list is fetched and add project requires login', (
    tester,
  ) async {
    final api = ApiClient(
      baseUrl: 'http://example.test',
      client: MockClient((request) async {
        if (request.url.path == '/api/v1/projects/') {
          return http.Response(
            '[{"id":"one","title":"Portfolio","description":"My work","tech_stack":"web-development","project_url":"https://example.com"}]',
            200,
          );
        }
        return http.Response('Not found', 404);
      }),
    );
    addTearDown(api.dispose);
    await tester.pumpWidget(MyApp(apiClient: api));
    await tester.ensureVisible(find.text('Lihat Proyek'));
    await tester.tap(find.text('Lihat Proyek'));
    await tester.pumpAndSettle();
    expect(find.text('Portfolio'), findsOneWidget);
    await tester.tap(find.text('Portfolio'));
    await tester.pumpAndSettle();
    expect(find.text('My work'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Tambah Proyek'));
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextFormField, 'Nama pengguna'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Kata sandi'), findsOneWidget);
  });
}
