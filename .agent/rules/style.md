---
trigger: always_on
---

# Project Operational Rules

1. **Error Checking**: Always check errors using the `dart-mcp-server` (`analyze_files` or `get_runtime_errors`) after every modification or action to ensure code stability.
2. **Clean Architecture**: Adhere strictly to Clean Architecture principles.
   - Separate code into `Presentation` (UI, BLoC), `Domain` (Entities, UseCases), and `Data` (Repositories, DataSources) layers.
   - Dependencies should flow inwards (Data -> Domain <- Presentation).
3. **Dependencies**: Always use the latest stable versions of packages. When adding new packages, prefer the most up-to-date and continuously maintained options.
4. **Data Models**: Use `freezed` and `json_serializable` for all data models and state classes to ensure immutability and robust JSON serialization.
   - Always run `dart run build_runner build --delete-conflicting-outputs` after modifying freezed models.
5. **State Management**: Use `flutter_bloc` with `freezed` states and events.

6. **CODE**: For every file (not generated file), keep max line code 300