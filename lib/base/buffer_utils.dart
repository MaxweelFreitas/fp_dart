/// Builds a generic FlatBuffer buffer.
///
/// This function creates a FlatBuffer using the provided [buildFn],
/// which must return the offset of the root object.
///
/// - [initialSize]: Initial buffer size in bytes (e.g., 256, 512).
/// - [buildFn]: Function that receives the builder and returns the offset of the object.
/// - [debug]: If `true`, prints creation logs for debugging.
/// - [validate]: If `true`, checks whether the returned offset is valid (> 0).
///
/// ### Example:
/// ```dart
/// import 'buffer_utils.dart';
/// import 'example_generated.dart' as example;
///
/// final buffer = buildFlatBuffer(
///   initialSize: 256,
///   debug: true,
///   validate: true,
///   buildFn: (builder) {
///     final person = example.PersonObjectBuilder(name: 'Alice', age: 28);
///     return person.finish(builder);
///   },
/// );
/// ```
library buffer_utils;

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;

import 'const.dart';

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
