import 'package:dio/dio.dart';
import 'package:flutter_project/core/utils/failure.dart';
import 'package:flutter_project/src/data_sources/user_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_project/core/services/http_client.dart';

import '../entities/entity_helpers.dart';
import 'user_data_source_test.mocks.dart';

@GenerateMocks([HttpClientService])
void main() {
  late UserDataSourceImpl dataSource;
  late MockHttpClientService mockHttpClientService;

  setUp(() {
    mockHttpClientService = MockHttpClientService();
    dataSource = UserDataSourceImpl(client: mockHttpClientService);
  });

  group('getUsers', () {
    test('should throw UnexpectedFailure()', () async {
      when(mockHttpClientService.get(
        path: anyNamed('path'),
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenThrow(Exception());

      expect(
        () async => await dataSource.getUsers(pages: 1, limit: 10),
        throwsA(isA<UnexpectedFailure>()),
      );
    });
    test('should return list of users', () async {
      final response = Response(
        statusCode: 201,
        data: {'data': usersJson},
        requestOptions: RequestOptions(data: [], path: '/'),
      );
      when(mockHttpClientService.get(
        path: anyNamed('path'),
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => response);

      final result = await dataSource.getUsers(pages: 1, limit: 10);

      expect(result, users);

      verify(mockHttpClientService.get(
        path: 'user',
        queryParameters: {'limit': 10, 'page': 1},
        options: anyNamed('options'),
      ));
    });
  });

  group('getUser', () {
    test('should throw UnexpectedFailure()', () async {
      when(mockHttpClientService.get(
        path: anyNamed('path'),
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenThrow(Exception());

      expect(
        () async => await dataSource.getUser(id: 'anyId'),
        throwsA(isA<UnexpectedFailure>()),
      );
    });

    test('should return user', () async {
      final response = Response(
        statusCode: 201,
        data: userJson,
        requestOptions: RequestOptions(data: [], path: '/'),
      );
      when(mockHttpClientService.get(
        path: anyNamed('path'),
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => response);

      final result = await dataSource.getUser(id: 'anyId');

      expect(result, user);

      verify(mockHttpClientService.get(
        path: 'user/anyId',
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      ));
    });
  });
}
