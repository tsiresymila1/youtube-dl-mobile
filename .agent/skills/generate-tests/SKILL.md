---
name: Unit Test Generator
description: Generates unit tests for Clean Architecture components using Mockito and BlocTest.
---

# Unit Test Generator

Use this skill when asked to "write tests" or "test this feature".

## 1. Bloc Tests
Target: `lib/features/<feature>/presentation/bloc/<feature>_bloc.dart`
Output: `test/features/<feature>/presentation/bloc/<feature>_bloc_test.dart`

**Template:**
```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// Generate mocks
@GenerateMocks([FeatureUseCase])
import 'feature_bloc_test.mocks.dart';

void main() {
  late FeatureBloc bloc;
  late MockFeatureUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockFeatureUseCase();
    bloc = FeatureBloc(useCase: mockUseCase);
  });

  blocTest<FeatureBloc, FeatureState>(
    'emits [Loading, Loaded] when Event is added',
    build: () {
      when(mockUseCase.call(any)).thenAnswer((_) async => Right(data));
      return bloc;
    },
    act: (bloc) => bloc.add(const FeatureEvent.started()),
    expect: () => [
      const FeatureState.loading(),
      const FeatureState.loaded(data),
    ],
  );
}
```

## 2. Repository Tests
Target: `lib/features/<feature>/data/repositories/<feature>_repository_impl.dart`
Output: `test/features/<feature>/data/repositories/<feature>_repository_impl_test.dart`

**Strategy:**
- Mock the `RemoteDataSource`.
- Verify that `repository.getData()` calls `dataSource.getData()`.
- Test both Success and Failure (Exception) cases.

## 3. Post-Action
- Run `dart run build_runner build --delete-conflicting-outputs` to generate the mock files.
