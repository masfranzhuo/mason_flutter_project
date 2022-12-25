![Test](https://github.com/masfranzhuo/{{project_name.snakeCase()}}/workflows/Test/badge.svg)
[![codecov](https://codecov.io/gh/masfranzhuo/{{project_name.snakeCase()}}/branch/main/graph/badge.svg?token=ED78PFGNFG)](https://codecov.io/gh/masfranzhuo/{{project_name.snakeCase()}})

# {{project_name.snakeCase()}}

A new Flutter project.

## Getting Started

Run this command

```
> flutter pub get
> flutter pub run build_runner build
> flutter pub run easy_localization:generate --source-dir ./assets/i18n -f keys -o locale_keys.g.dart
```

Create `.env` and `.env_dev` file on root folder
```
ENV = DEVELOPMENT
APP_ID = XXXXXX // get API key at https://dummyapi.io
```

## Build

Run this command to build APK based on environment [*]

```
> flutter build apk --release --dart-define=ENV=[dev]
```

## Test

Run this command if your device support genhtml

```
> flutter test --coverage && genhtml coverage/lcov.info --output=coverage
```

Run this command if you need to build coverage view manual
```
> flutter test --coverage
```

### Features
- Clean Architecture
- Environment
- Responsive
- Easy Localization as Localization
- Dio as Http Service
- Flutter Secure Storage, Hive, Isar, Drift as Local Storage
- Device Preview to preview from any device
