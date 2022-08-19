![Test](https://github.com/masfranzhuo/{{project_name.snakeCase()}}/workflows/Test/badge.svg)
[![codecov](https://codecov.io/gh/masfranzhuo/{{project_name.snakeCase()}}/branch/main/graph/badge.svg?token=ED78PFGNFG)](https://codecov.io/gh/masfranzhuo/{{project_name.snakeCase()}})

# {{project_name.snakeCase()}}

A new Flutter project.

## Getting Started

Run this command

```
> flutter pub get
> flutter pub run build_runner build
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
- Hive, Isar and sqflite as Local Storage
- Device Preview to preview from any device
