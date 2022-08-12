import 'package:dartz/dartz.dart';
import 'package:{{project_name.snakeCase()}}/core/config/general_config.dart';
import 'package:{{project_name.snakeCase()}}/core/utils/failure.dart';
import 'package:{{project_name.snakeCase()}}/src/data_sources/user_local_data_source.dart';
import 'package:{{project_name.snakeCase()}}/src/entities/location_isar.dart';
import 'package:{{project_name.snakeCase()}}/src/entities/user.dart';
import 'package:{{project_name.snakeCase()}}/src/entities/user_isar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider/path_provider.dart';

import '../entities/entity_helpers.dart';
import '../entities/isar_entity_helpers.dart';
import 'user_local_data_source_test.mocks.dart';

@GenerateMocks([
  UserIsar,
  User,
], customMocks: [
  MockSpec<Isar>(
    unsupportedMembers: {#txnSync, #writeTxnSync},
    returnNullOnMissingStub: true,
  ),
  MockSpec<IsarCollection<UserIsar>>(
    returnNullOnMissingStub: true,
  ),
  MockSpec<IsarLink<LocationIsar>>(
    returnNullOnMissingStub: true,
  ),
])
void main() {
  late UserLocalDataSourceImpl localDataSourceWithMock;
  late UserLocalDataSourceImpl localDataSource;
  late Isar isar;
  late MockIsar mockIsar;

  late MockIsarCollection mockIsarCollectionUser;
  late MockIsarLink mockIsarLinkLocation;

  late MockUserIsar mockUserIsar;
  late MockUser mockUser;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Isar.initializeIsarCore(download: true);
    isar = await Isar.open(
      [LocationIsarSchema, UserIsarSchema],
      directory: (await getApplicationSupportDirectory()).path,
    );

    mockIsar = MockIsar();

    mockIsarCollectionUser = MockIsarCollection();
    mockIsarLinkLocation = MockIsarLink();

    mockUserIsar = MockUserIsar();
    mockUser = MockUser();

    localDataSourceWithMock = UserLocalDataSourceImpl(isar: mockIsar);
    localDataSource = UserLocalDataSourceImpl(isar: isar);
  });

  tearDown(() => isar.close(deleteFromDisk: true));

  group('deleteAllUser', () {
    test('should throw LocalStorageFailure()', () async {
      when(mockIsar.writeTxn(any)).thenThrow(Exception());

      expect(
        () async => await localDataSourceWithMock.deleteAllUser(),
        throwsA(isA<LocalStorageFailure>()),
      );

      verify(mockIsar.writeTxn((any)));
    });

    test('should return 1, when delete data exist', () async {
      await localDataSource.deleteAllUser();

      final result = await isar.writeTxn(
        () async {
          final UserIsar tempUserIsar = UserIsar.fromUser(user);
          await isar.userIsars.putByIdString(tempUserIsar);

          final idStrings =
              await isar.userIsars.where().idStringProperty().findAll();
          return await isar.userIsars.deleteAllByIdString(idStrings);
        },
      );
      expect(result, 1);
    });

    test('should return 0, when delete data not exist', () async {
      await localDataSource.deleteAllUser();

      final result = await isar.writeTxn(
        () async {
          return await isar.userIsars.deleteAllByIdString(['anyId']);
        },
      );
      expect(result, 0);
    });
  });

  group('deleteUser', () {
    test('should throw LocalStorageFailure()', () async {
      when(mockIsar.writeTxn(any)).thenThrow(Exception());

      expect(
        () async => await localDataSourceWithMock.deleteUser(id: 'anyId'),
        throwsA(isA<LocalStorageFailure>()),
      );

      verify(mockIsar.writeTxn((any)));
    });

    test('should return true, when delete data exist', () async {
      await localDataSource.deleteUser(id: userIsar.idString);

      final result = await isar.writeTxn(
        () async {
          final UserIsar tempUserIsar = UserIsar.fromUser(user);
          await isar.userIsars.putByIdString(tempUserIsar);

          return await isar.userIsars.deleteByIdString(tempUserIsar.idString);
        },
      );
      expect(result, true);
    });

    test('should return false, when delete data not exist', () async {
      await localDataSource.deleteUser(id: 'anyId');

      final result = await isar.writeTxn(
        () async {
          return await isar.userIsars.deleteByIdString('anyId');
        },
      );
      expect(result, false);
    });
  });

  group('getUser', () {
    test('should throw LocalStorageFailure()', () async {
      when(mockIsar.userIsars).thenReturn(mockIsarCollectionUser);
      when(mockIsarCollectionUser.getByIdString('anyId')).thenThrow(
        Exception(),
      );

      expect(
        () async => await localDataSourceWithMock.getUser(id: 'anyId'),
        throwsA(isA<LocalStorageFailure>()),
      );

      verifyInOrder([
        mockIsar.userIsars,
        mockIsarCollectionUser.getByIdString('anyId'),
      ]);
    });

    test('should return user', () async {
      when(mockIsar.userIsars).thenReturn(mockIsarCollectionUser);
      when(mockIsarCollectionUser.getByIdString('anyId')).thenAnswer(
        (_) async => mockUserIsar,
      );
      when(mockUserIsar.location).thenReturn(mockIsarLinkLocation);
      when(mockIsarLinkLocation.load()).thenAnswer((_) async => unit);
      when(mockUserIsar.toUser()).thenReturn(mockUser);

      final result = await localDataSourceWithMock.getUser(id: 'anyId');

      expect(result, mockUser);

      verifyInOrder([
        mockIsar.userIsars,
        mockIsarCollectionUser.getByIdString('anyId'),
        mockUserIsar.location,
        mockIsarLinkLocation.load(),
        mockUserIsar.toUser(),
      ]);
    });
  });

  group('getUsers', () {
    test('should throw LocalStorageFailure()', () async {
      when(mockIsar.userIsars).thenReturn(mockIsarCollectionUser);
      when(mockIsarCollectionUser.where()).thenThrow(Exception());

      expect(
        () async => await localDataSourceWithMock.getUsers(page: 1),
        throwsA(isA<LocalStorageFailure>()),
      );

      verifyInOrder([
        mockIsar.userIsars,
        mockIsarCollectionUser.where(),
      ]);
    });

    test('should call offset and limit, when page args is set', () async {
      await isar.writeTxn(
        () async {
          final UserIsar tempUserIsar = UserIsar.fromUser(user);
          return await isar.userIsars.putByIdString(tempUserIsar);
        },
      );

      final result = await localDataSource.getUsers(page: 1);

      final userIsars = await isar.userIsars
          .where()
          .offset(0)
          .limit(Pagination.limit)
          .findAll();
      final List<User> users = [];
      for (UserIsar userIsar in userIsars) {
        final user = userIsar.toUser();
        users.add(user);
      }

      expect(result, users);
    });

    test('should not call offset and limit, when page args not set', () async {
      await isar.writeTxn(
        () async {
          final UserIsar tempUserIsar = UserIsar.fromUser(user);
          return await isar.userIsars.putByIdString(tempUserIsar);
        },
      );

      final result = await localDataSource.getUsers();

      final userIsars = await isar.userIsars.where().findAll();
      final List<User> users = [];
      for (UserIsar userIsar in userIsars) {
        final user = userIsar.toUser();
        users.add(user);
      }

      expect(result, users);
    });
  });

  group('setUser', () {
    test('should throw LocalStorageFailure()', () async {
      when(mockIsar.writeTxn(any)).thenThrow(Exception());

      expect(
        () async => await localDataSourceWithMock.setUser(user: user),
        throwsA(isA<LocalStorageFailure>()),
      );

      verify(mockIsar.writeTxn((any)));
    });

    test('should return 1, when insert succeed', () async {
      await localDataSource.setUser(user: user);

      final result = await isar.writeTxn(
        () async {
          final UserIsar tempUserIsar = UserIsar.fromUser(user);
          return await isar.userIsars.putByIdString(tempUserIsar);
        },
      );
      expect(result, 1);
    });
  });

  group('setUsers', () {
    test('should throw LocalStorageFailure()', () async {
      when(mockIsar.writeTxn(any)).thenThrow(Exception());

      expect(
        () async => await localDataSourceWithMock.setUsers(users: users),
        throwsA(isA<LocalStorageFailure>()),
      );

      verify(mockIsar.writeTxn((any)));
    });

    test('should return 1, when insert succeed', () async {
      await localDataSource.setUsers(users: users);

      final result = await isar.writeTxn(
        () async {
          for (User user in users) {
            final UserIsar tempUserIsar = UserIsar.fromUser(user);
            await isar.userIsars.putByIdString(tempUserIsar);
          }
          return 1;
        },
      );
      expect(result, 1);
    });
  });
}
