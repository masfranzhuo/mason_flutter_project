![Test](https://github.com/masfranzhuo/{{project_name.snakeCase()}}/workflows/Test/badge.svg)
[![codecov](https://codecov.io/gh/masfranzhuo/{{project_name.snakeCase()}}/branch/development/graph/badge.svg?token=ED78PFGNFG)](https://codecov.io/gh/masfranzhuo/{{project_name.snakeCase()}})

# {{project_name.snakeCase()}}

A new Flutter project architecture.

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
- Http Service