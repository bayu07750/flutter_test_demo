# flutter_test_demo

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



## Unit Test

- package `test` - flutter pub add dev:test
- `test()`
- `expect(actual, expected)`
- `equals()` - by default matching by memory, but if you change this behaviour override operator ==
- TypeMatcher
    - isA<T>
        - Reuse this using creating variable TypeMatcher
    - isList
    - isMap
- group
- setUp
- setUpAll
- tearDown
- tearDownAll

### Mock

- `mockito` need a code generation.
- `mocktail`
    - Mock
    - when
    - thenReturn - untuk data yang bersifat sinkron
    - thenAnswer - untuk data yang bersifat asinkron
    - thenThrow
    - verify
- 

### Cheatsheet

## Widget Test

## Integration Test

## ...