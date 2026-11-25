import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

void main() {
  test('project API maps JSON, omits server ID and sends token', () async {
    final client = ApiClient(
      baseUrl: 'http://example.test',
      client: MockClient((request) async {
        if (request.method == 'GET') {
          return http.Response(
            jsonEncode([
              {
                'id': 'uuid',
                'title': 'Portfolio',
                'description': 'Web',
                'tech_stack': 'web-development',
                'project_url': 'https://example.com',
                'project_image_url': null,
              },
            ]),
            200,
          );
        }
        expect(request.headers['authorization'], 'Token key');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['tech_stack'], 'web-development');
        expect(body.containsKey('id'), isFalse);
        return http.Response(jsonEncode({...body, 'id': 'new-uuid'}), 201);
      }),
    );
    addTearDown(client.dispose);
    final projects = await client.getProjects();
    expect(projects.single.id, 'uuid');
    expect(projects.single.projectImageUrl, '');
    final created = await client.createProject(projects.single, token: 'key');
    expect(created.id, 'new-uuid');
  });

  test('education API maps dates and authenticated payload', () async {
    final client = ApiClient(
      baseUrl: 'http://example.test',
      client: MockClient((request) async {
        expect(request.url.path, '/api/v1/education/');
        if (request.method == 'GET') {
          return http.Response(
            '[{"id":"one","institution":"UI","major":"CS","started_at":"2023-08-15"}]',
            200,
          );
        }
        expect(request.headers['authorization'], 'Token key');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['started_at'], '2023-08-15');
        expect(body.containsKey('id'), isFalse);
        return http.Response(jsonEncode({...body, 'id': 'two'}), 201);
      }),
    );
    addTearDown(client.dispose);
    final education = (await client.getEducations()).single;
    expect(education.startedAt, '2023-08-15');
    final created = await client.createEducation(education, token: 'key');
    expect(created.id, 'two');
  });

  test('login stores token and failed logout still clears state', () async {
    final client = ApiClient(
      baseUrl: 'http://example.test',
      client: MockClient((request) async {
        if (request.url.path.endsWith('/token/')) {
          expect(jsonDecode(request.body), {
            'username': 'admin',
            'password': 'secret',
          });
          return http.Response('{"token":"key"}', 200);
        }
        expect(request.headers['authorization'], 'Token key');
        return http.Response('unavailable', 500);
      }),
    );
    addTearDown(client.dispose);
    final auth = AuthState(client);
    addTearDown(auth.dispose);
    await auth.login('admin', 'secret');
    expect(auth.isLoggedIn, isTrue);
    await expectLater(auth.logout(), throwsA(isA<ApiException>()));
    expect(auth.isLoggedIn, isFalse);
  });
}
