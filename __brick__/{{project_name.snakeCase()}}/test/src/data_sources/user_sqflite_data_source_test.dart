import 'dart:convert';

import 'package:{{project_name.snakeCase()}}/core/services/sqflite.dart';
import 'package:{{project_name.snakeCase()}}/core/utils/failure.dart';
import 'package:{{project_name.snakeCase()}}/src/data_sources/user_sqflite_data_source.dart';
import 'package:{{project_name.snakeCase()}}/src/entities/location.dart';
import 'package:{{project_name.snakeCase()}}/src/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/entity_helpers.dart';
import 'user_sqflite_data_source_test.mocks.dart';

@GenerateMocks([SqfliteService, User, Location])
void main() {
  late UserSqfliteDataSourceImpl sqfliteDataSource;
  late MockSqfliteService mockSqfliteService;

  late MockUser mockUser;
  late MockLocation mockLocation;
  late List<MockUser> mockUsers;

  setUp(() {
    mockSqfliteService = MockSqfliteService();

    mockUser = MockUser();
    mockLocation = MockLocation();
    mockUsers = [mockUser];

    sqfliteDataSource = UserSqfliteDataSourceImpl(
      sqfliteService: mockSqfliteService,
    );
  });

  group('getUser', () {
    test('should throw LocalStorageFailure()', () async {
      when(mockSqfliteService.get(
        table: anyNamed('table'),
        id: anyNamed('id'),
        columns: anyNamed('columns'),
      )).thenThrow(Exception());

      expect(
        () async => await sqfliteDataSource.getUser(id: 'anyId'),
        throwsA(isA<LocalStorageFailure>()),
      );

      verify(mockSqfliteService.get(
        table: anyNamed('table'),
        id: anyNamed('id'),
        columns: anyNamed('columns'),
      ));
    });

    test('should return user, when user location empty', () async {
      when(mockSqfliteService.get(
        table: anyNamed('table'),
        id: anyNamed('id'),
        columns: anyNamed('columns'),
      )).thenAnswer((_) async => user.copyWith(location: null).toJson());

      final result = await sqfliteDataSource.getUser(id: 'anyId');

      expect(result, user.copyWith(location: null));

      verify(
        mockSqfliteService.get(
          table: anyNamed('table'),
          id: anyNamed('id'),
          columns: anyNamed('columns'),
        ),
      );
    });

    test('should return user, when user location exist', () async {
      /// encode for the right input
      ///
      userJson['location'] = jsonEncode(userJson['location']);

      when(mockSqfliteService.get(
        table: anyNamed('table'),
        id: anyNamed('id'),
        columns: anyNamed('columns'),
      )).thenAnswer((_) async => userJson);

      final result = await sqfliteDataSource.getUser(id: 'anyId');

      expect(result, user);

      verify(
        mockSqfliteService.get(
          table: anyNamed('table'),
          id: anyNamed('id'),
          columns: anyNamed('columns'),
        ),
      );
    });
  });

  group('getUsers', () {
    test('should throw LocalStorageFailure()', () async {
      when(mockSqfliteService.getList(
        table: anyNamed('table'),
        columns: anyNamed('columns'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenThrow(Exception());

      expect(
        () async => await sqfliteDataSource.getUsers(page: 1),
        throwsA(isA<LocalStorageFailure>()),
      );

      verify(mockSqfliteService.getList(
        table: anyNamed('table'),
        columns: anyNamed('columns'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      ));
    });

    test('should return list of users, when data exist in local storage',
        () async {
      when(mockSqfliteService.getList(
        table: anyNamed('table'),
        columns: anyNamed('columns'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => List<Map<String, dynamic>>.from(usersJson));

      final result = await sqfliteDataSource.getUsers(page: 1);

      expect(result, users);

      verify(mockSqfliteService.getList(
        table: anyNamed('table'),
        columns: anyNamed('columns'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      ));
    });

    test('should return empty list of users, when no data in local storage',
        () async {
      when(mockSqfliteService.getList(
        table: anyNamed('table'),
        columns: anyNamed('columns'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => null);

      final result = await sqfliteDataSource.getUsers(page: 1);

      expect(result, []);

      verify(mockSqfliteService.getList(
        table: anyNamed('table'),
        columns: anyNamed('columns'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      ));
    });
  });

  group('setUser', () {
    test('should throw LocalStorageFailure()', () async {
      when(mockUser.toJson()).thenReturn(
        user.copyWith(location: null).toJson(),
      );
      when(mockUser.location).thenReturn(null);
      when(mockSqfliteService.insert(
        table: anyNamed('table'),
        map: anyNamed('map'),
      )).thenThrow(Exception());

      expect(
        () async => await sqfliteDataSource.setUser(user: mockUser),
        throwsA(isA<LocalStorageFailure>()),
      );

      verifyInOrder([
        mockUser.toJson(),
        mockUser.location,
        mockSqfliteService.insert(
          table: anyNamed('table'),
          map: anyNamed('map'),
        ),
      ]);
    });

    test('should not call location.toJson(), when user location empty',
        () async {
      when(mockUser.toJson()).thenReturn(
        user.copyWith(location: null).toJson(),
      );
      when(mockUser.location).thenReturn(null);
      when(mockSqfliteService.insert(
        table: anyNamed('table'),
        map: anyNamed('map'),
      )).thenAnswer((_) async => 1);

      await sqfliteDataSource.setUser(user: mockUser);

      verifyInOrder([
        mockUser.toJson(),
        mockUser.location,
        mockSqfliteService.insert(
          table: anyNamed('table'),
          map: anyNamed('map'),
        ),
      ]);
    });

    test('should call location.toJson(), when user location exist', () async {
      when(mockUser.toJson()).thenReturn(userJson);
      when(mockUser.location).thenReturn(mockLocation);
      when(mockLocation.toJson()).thenReturn(user.location!.toJson());
      when(mockSqfliteService.insert(
        table: anyNamed('table'),
        map: anyNamed('map'),
      )).thenAnswer((_) async => 1);

      await sqfliteDataSource.setUser(user: mockUser);

      verifyInOrder([
        mockUser.toJson(),
        mockUser.location,
        mockLocation.toJson(),
        mockSqfliteService.insert(
          table: anyNamed('table'),
          map: anyNamed('map'),
        ),
      ]);
    });
  });

  group('setUsers', () {
    test('should throw LocalStorageFailure()', () async {
      for (var mockUser in mockUsers) {
        when(mockUser.toJson()).thenReturn(userJson);
      }
      when(mockSqfliteService.insertBulk(
        table: anyNamed('table'),
        maps: anyNamed('maps'),
      )).thenThrow(Exception());

      expect(
        () async => await sqfliteDataSource.setUsers(users: mockUsers),
        throwsA(isA<LocalStorageFailure>()),
      );

      verify(mockUser.toJson()).called(mockUsers.length);
      verify(mockSqfliteService.insertBulk(
        table: anyNamed('table'),
        maps: anyNamed('maps'),
      ));
    });

    test('should verify insertBulk', () async {
      for (var mockUser in mockUsers) {
        when(mockUser.toJson()).thenReturn(userJson);
      }
      when(mockSqfliteService.insertBulk(
        table: anyNamed('table'),
        maps: anyNamed('maps'),
      )).thenAnswer((_) async => [1]);

      await sqfliteDataSource.setUsers(users: mockUsers);

      verify(mockUser.toJson()).called(mockUsers.length);
      verify(mockSqfliteService.insertBulk(
        table: anyNamed('table'),
        maps: anyNamed('maps'),
      ));
    });
  });

  group('deleteUser', () {
    test('should throw LocalStorageFailure()', () async {
      when(mockSqfliteService.delete(
        table: anyNamed('table'),
        id: anyNamed('id'),
      )).thenThrow(Exception());

      expect(
        () async => await sqfliteDataSource.deleteUser(id: 'anyId'),
        throwsA(isA<LocalStorageFailure>()),
      );

      verify(mockSqfliteService.delete(
        table: anyNamed('table'),
        id: anyNamed('id'),
      ));
    });

    test('should verify delete', () async {
      when(mockSqfliteService.delete(
        table: anyNamed('table'),
        id: anyNamed('id'),
      )).thenAnswer((_) async => 1);

      await sqfliteDataSource.deleteUser(id: 'anyId');

      verify(mockSqfliteService.delete(
        table: anyNamed('table'),
        id: anyNamed('id'),
      ));
    });
  });

  group('deleteAllUser', () {
    test('should throw LocalStorageFailure()', () async {
      when(mockSqfliteService.deleteAll(
        table: anyNamed('table'),
      )).thenThrow(Exception());

      expect(
        () async => await sqfliteDataSource.deleteAllUser(),
        throwsA(isA<LocalStorageFailure>()),
      );

      verify(mockSqfliteService.deleteAll(
        table: anyNamed('table'),
      ));
    });

    test('should verify deleteUser', () async {
      when(mockSqfliteService.deleteAll(
        table: anyNamed('table'),
      )).thenAnswer((_) async => 1);

      await sqfliteDataSource.deleteAllUser();

      verify(mockSqfliteService.deleteAll(
        table: anyNamed('table'),
      ));
    });
  });
}
