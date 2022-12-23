![Test](https://github.com/masfranzhuo/flutter_project/workflows/Test/badge.svg)
[![codecov](https://codecov.io/gh/masfranzhuo/flutter_project/branch/main/graph/badge.svg?token=ED78PFGNFG)](https://codecov.io/gh/masfranzhuo/flutter_project)

# flutter_project

A new Flutter project.

## Getting Started

Run this command

```
> flutter pub get
> flutter pub run build_runner build
> flutter pub run easy_localization:generate --source-dir ./assets/i18n
> flutter pub run easy_localization:generate --source-dir ./assets/i18n -f keys -o locale_keys.g.dart
```

Create `.env` and `.env_dev` file on root folder
```
ENV = DEVELOPMENT
APP_ID = XXXXXX // get API key at https://dummyapi.io
```

### Features
- Clean Architecture
- Environment
- Localization
- Responsive
- Dio as Http Service
- Flutter Secure Storagte, Hive, Isar and sqflite as Local Storage
- Device Preview to preview from any device
