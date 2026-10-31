# Code Style Guidelines

> **Link**: [AGENTS.md](#agents-md-cx-dompetqu) | [App Logger](app-logger.md)

## Overview

This document consolidates the code style conventions, critical rules, and best practices for the `cx-dompetqu` Flutter project. These guidelines are enforced via `flutter analyze` with `flutter_skill_lints` and `riverpod_lint` plugins, and validated by Dart Decimate.

---

## Critical Rules (R1–R27)

| ID | Rule | Core Principle |
|----|------|----------------|
| **R1** | `dart analyze` exits 0 with `flutter_skill_lints` + `riverpod_lint`; `dart_decimate_gate.py` exits 0 after zero-finding scan |
| **R2** | **All providers use `@riverpod` / `@Riverpod` codegen** — no manual provider classes or legacy provider families |
| **R3** | Guard async gaps with `ref.mounted` / `context.mounted`; `finally` uses `if (ref.mounted) { ... }` |
| **R4** | Widgets are public classes; no `_buildXxx()`, widget top-level helpers, or private widget classes except `State` |
| **R5** | Nullability is semantic; no empty/null/bool sentinel fallbacks, `value!`, nullable collections, or raw required domain strings |
| **R6** | All user-facing strings, tooltips, semantics, and visible accessibility copy use `AppLocalizations` |
| **R7** | Immutable state/entities use **sealed Freezed**, one declaration per file, native `switch`, and VO map/when disabled |
| **R8** | `presentation/widgets/` renders immutable inputs + emits typed callbacks; screens/routes/notifiers own navigation, workflow, domain state, and infrastructure |
| **R9** | Duplicate behavior in 2+ classes becomes a small stateless `*Mixin` with an `on` clause |
| **R17** | Keep control flow flat after exits; remove unnecessary `else` after `return` / `throw` / `break` / `continue` |

---

## Riverpod 2025 Best Practices

### Provider Selection Guide

| Pattern | Example |
|---------|---------|
| **Immutable/Computed Values** | ```dart @riverpod String apiKey(Ref ref) => 'YOUR_API_KEY'; ``` |
| **Simple Synchronous State** | ```dart @riverpod class Counter extends _$Counter { @override int build() => 0; void increment() => state++; void decrement() => state = max(0, state - 1); } ``` |
| **Async Data with Mutations** (PREFERRED) | ```dart @riverpod class TodoList extends _$TodoList { @override Future<List<Todo>> build() async { final repo = ref.watch(todoRepositoryProvider); return repo.fetchTodos(); } Future<void> addTodo(String title) async { state = const AsyncLoading(); state = await AsyncValue.guard(() async { final repo = ref.read(todoRepositoryProvider); await repo.createTodo(title); return repo.fetchTodos(); }); } } ``` |
| **Real-time Streams Only** | ```dart @riverpod Stream<User?> authState(Ref ref) => FirebaseAuth.instance.authStateChanges(); ``` |

**Key Rule**: Prefer `AsyncNotifierProvider` over `FutureProvider`/`StreamProvider` for better consistency and mutation support.

### Code Generation Setup

**Dependencies** (`pubspec.yaml`):
```yaml
dev_dependencies:
  build_runner: ^2.4.0
  riverpod_generator: ^2.4.0
  riverpod_lint: ^2.3.0
  custom_lint: ^0.6.0
```

**File Template** (every provider file):
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filename.g.dart';  // REQUIRED

@riverpod
class MyProvider extends _$MyProvider {
  @override
  Future<Data> build() async => fetchData();
}
```

**Run Generator**:
```bash
# Watch mode (RECOMMENDED during development)
dart run build_runner watch -d

# One-time generation
dart run build_runner build --delete-conflicting-outputs
```

### Performance Optimization

**Use `ref.select()` for Specific Fields**:
```dart
// ❌ BAD: Rebuilds on ANY product change
final product = ref.watch(productProvider);
// ✅ GOOD: Only rebuilds when price changes
final price = ref.watch(productProvider.select((p) => p.price));
```

**`ref.watch()` vs `ref.select()` vs `ref.read()` vs `ref.listen()`**:

| Method | When to Use |
|--------|-------------|
| **`ref.watch()`** | Subscribe to changes (use in `build()`) |
| **`ref.select()`** | Subscribe to specific property (optimize rebuilds) |
| **`ref.read()`** | One-time read with NO subscription (event handlers only) |
| **`ref.listen()`** | Side effects (navigation, snackbars, logging) |

**Avoid Watching in Loops**:
```dart
// ❌ BAD: Causes performance issues
ListView.builder(
  itemBuilder: (context, index) {
    final todo = ref.watch(todoProvider(ids[index])); // DON'T!
    return ListTile(...);
  },
);

// ✅ GOOD: Separate widget for each item
class TodoItem extends ConsumerWidget {
  const TodoItem({required this.todoId});
  final String todoId;
  @override Widget build(BuildContext context, WidgetRef ref) {
    final todo = ref.watch(todoProvider(todoId));
    return ListTile(title: Text(todo.title));
  }
}

class TodoList extends ConsumerWidget {
  @override Widget build(BuildContext context, WidgetRef ref) {
    final ids = ref.watch(todoIdsProvider);
    return ListView.builder(itemCount: ids.length, itemBuilder: (context, index) => TodoItem(todoId: ids[index]));
  }
}
```

### Repository Pattern Architecture

**Data Layer** - Repository:
```dart
@riverpod
TodoRepository todoRepository(Ref ref) => TodoRepository(dio: ref.watch(dioProvider));

class TodoRepository {
  final Dio dio;
  Future<List<Todo>> fetchTodos() async => (await dio.get('/todos')).map((json) => Todo.fromJson(json)).toList();
}
```

**Application Layer** - State Management:
```dart @riverpod class TodoList extends _$TodoList { @override Future<List<Todo>> build() async { final repo = ref.watch(todoRepositoryProvider); return repo.fetchTodos(); } Future<void> addTodo(String title) async { state = const AsyncLoading(); state = await AsyncValue.guard(() async { await ref.read(todoRepositoryProvider).createTodo(title); return ref.read(todoRepositoryProvider).fetchTodos(); }); } }
```

**Presentation Layer** - UI:
```dart class TodoListScreen extends ConsumerWidget { @override Widget build(BuildContext context, WidgetRef ref) { final todosAsync = ref.watch(todoListProvider); return Scaffold(body: todosAsync.when(data: (todos) => ListView.builder(...), loading: () => const CircularProgressIndicator(), error: (e, _) => ErrorView(e))); } }
```

### Family Providers

```dart @riverpod Future<User> user(Ref ref, String id) async { final dio = ref.watch(dioProvider); final response = await dio.get('/users/$id'); return User.fromJson(response.data); }

final user = ref.watch(userProvider('123'));
```

### AutoDispose and Caching

Code generation makes providers **auto-dispose by default**:
```dart @Riverpod(keepAlive: true) Future<Config> config(Ref ref) async => loadConfig();

// Timed cache
@riverpod Future<String> timedCache(Ref ref) async { final data = await fetchData(); final link = ref.keepAlive(); Timer(const Duration(minutes: 5), link.close); return data; }
```

### Error Handling

```dart @riverpod class TodoList extends _$TodoList { @override Future<List<Todo>> build() async { try { final repository = ref.watch(todoRepositoryProvider); return await repository.fetchTodos(); } on DioException catch (e) { if (e.response?.statusCode == 401) { ref.read(authServiceProvider).logout(); throw UnauthorizedException(); } throw NetworkException(e.message); } catch (e) { throw UnexpectedException(e.toString()); } } }
```

### Testing

```dart test('TodoList fetches todos correctly', () async { final container = ProviderContainer.test(overrides: [todoRepositoryProvider.overrideWithValue(MockTodoRepository())]); final todos = await container.read(todoListProvider.future); expect(todos.length, 2); });
```

---

## General Flutter Patterns

### Freezed Data Models

```dart
@freezed class User with _$User {
  const factory User({
    required String id,
    required String name,
    @Default(false) bool isActive,
    DateTime? createdAt,
  }) = _User;
}

@freezed sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}
```

### go_router Navigation

```dart
final routerProvider = Provider<GoRouter>((ref) => GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
  ],
));
```

### Widget Patterns

- **`ConsumerWidget`** for Riverpod-dependent widgets
- **`HookConsumerWidget`** with `flutter_hooks` for animation effects
- **Separate widget per list item** (avoid watching in `ListView.builder`)

### Nullability

- No `value!` or sentinel fallbacks
- Use `@Default()` for Freezed initial values
- Semantic nullability - distinguish between "not loaded", "loading", "error", "empty"

### Accessibility

- All strings through `AppLocalizations`
- 48x48 tap targets
- Contrast ratios respected
- Text scaling support

---

## Analysis & Lint Configuration

### `analysis_options.yaml`

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
  errors:
    invalid_annotation_target: ignore
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true

linter:
  rules:
    - always_declare_return_types
    - avoid_dynamic_calls
    - avoid_print
    - avoid_type_to_string
    - cancel_subscriptions
    - close_sinks
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_final_locals
    - require_trailing_commas
    - unawaited_futures
    - use_super_parameters
```

### Critical Plugins

- `flutter_skill_lints` - enforces R1–R27
- `riverpod_lint` - enforces Riverpod codegen patterns
- `dart_decimate_gate.py` - zero-finding scan

---

## Testing Patterns

### Provider Tests

```dart
test('TodoList fetches todos correctly', () async {
  final container = ProviderContainer.test(
    overrides: [todoRepositoryProvider.overrideWithValue(MockTodoRepository())],
  );
  final todos = await container.read(todoListProvider.future);
  expect(todos.length, 2);
});
```

### Widget Tests

```dart
testWidgets('TodoListScreen displays todos', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [todoRepositoryProvider.overrideWithValue(MockTodoRepository())],
      child: const MaterialApp(home: TodoListScreen()),
    ),
  );
  await tester.pumpAndSettle();
  expect(find.text('Test Todo 1'), findsOneWidget);
});
```

---

## Anti-Patterns to AVOID

| Anti-Pattern | Fix |
|-------------|-----|
| `ref.read()` in `build()` to "optimize" | Use `ref.watch()` or `ref.select()` |
| Not disposing resources | Use `ref.onDispose(() => client.close())` |
| Multiple sources of truth (local + provider) | Single source of truth - provider only |
| Not invalidating dependent providers | `ref.invalidate(dependentProvider)` after mutations |
| `ref.watch()` in loops | Extract widget, watch at widget level |
| Business logic in widgets | Move to Notifiers/providers |

---

## Linking from AGENTS.md

This file is referenced in `@AGENTS.md` under the **Konvensi Kode** section. When updating code style conventions or critical rules, ensure AGENTS.md is also updated to maintain synchronization.

Key cross-references in AGENTS.md:
- **Design System** section → UiStyle, brand colors, widget usage
- **Testing** section → flutter_test patterns, fake HTTP idioms
- **Workflow Tim** → codegen rules, type checking
- **Konvensi Kode** → Indonesian comments, section comments, Freezed `@Default`
- **Skill Lokal** → `flutter`, `riverpod`, `flutter-riverpod-expert`, `building-flutter-apps`

---

## Update Protocol

When modifying code style conventions:

1. **Update `docs-dev/code_style.md`** with the changes
2. **Update `.agents/skills/building-flutter-apps/`** if critical rules change
3. **Update `AGENTS.md`** under relevant sections (Konvensi Kode, Testing, Workflow Tim)
4. **Run `flutter analyze`** to verify no new lint errors
5. **Commit all changes together** to maintain synchronization

---