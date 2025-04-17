/// FlatBuffer utilities.
///
/// This library provides helper functions to simplify the creation and reading
/// of FlatBuffer-encoded data structures.
library buffer_utils;

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;

import 'const.dart';

/// Builds a FlatBuffer-encoded buffer.
///
/// This function uses the provided [buildFn] to serialize an object using the
/// FlatBuffer format.
///
/// - [initialSize]: Optional initial buffer size in bytes (default: 256).
/// - [buildFn]: A function that receives a [fb.Builder] and returns the offset
///   of the root object.
/// - [debug]: If `true`, logs buffer creation steps.
/// - [validate]: If `true`, validates that the resulting offset is greater than zero.
///
/// ### Example:
/// ```dart
/// final buffer = buildFlatBuffer(
///   initialSize: 256,
///   debug: true,
///   validate: true,
///   buildFn: (builder) {
///     final person = PersonObjectBuilder(name: 'Alice', age: 28);
///     return person.finish(builder);
///   },
/// );
/// ```
Uint8List buildFlatBuffer({
  final int initialSize = 256,
  required final int Function(fb.Builder builder) buildFn,
  final bool debug = false,
  final bool validate = false,
}) {
  final builder = fb.Builder(initialSize: initialSize);

  if (debug) {
    print(
      '$orange[FlatBuffer] Initializing builder with $initialSize bytes...',
    );
  }

  final offset = buildFn(builder);

  if (validate && offset <= 0) {
    throw Exception('$orange[FlatBuffer] Invalid offset: $offset');
  }

  builder.finish(offset);

  if (debug) {
    print('$orange[FlatBuffer] Buffer finalized with offset: $offset');
    print(
      '$orange[FlatBuffer] Final buffer size: ${builder.buffer.lengthInBytes} bytes',
    );
  }

  return builder.buffer;
}

/// Reads a FlatBuffer-encoded buffer into a Dart object.
///
/// This function wraps the typical deserialization process using the provided
/// [fromBuffer] constructor or factory.
///
/// - [buffer]: A [Uint8List] containing the FlatBuffer-encoded data.
/// - [fromBuffer]: A function that converts the buffer into a Dart object
///   (e.g. `MyType.new`, or `(bytes) => MyType(bytes)`).
/// - [debug]: If `true`, logs buffer reading steps.
///
/// ### Example:
/// ```dart
/// final person = readFlatBuffer<Person>(
///   buffer,
///   Person.new,
///   debug: true,
/// );
/// ```
T readFlatBuffer<T>(
  final Uint8List buffer,
  final T Function(List<int>) fromBuffer, {
  final bool debug = false,
}) {
  if (debug) {
    print('$orange[FlatBuffer] Reading buffer with ${buffer.length} bytes...');
  }
  return fromBuffer(buffer);
}
