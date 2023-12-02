import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

DatabaseConnection connect() {
  return DatabaseConnection.delayed(Future(() async {
    final db = await WasmDatabase.open(
      databaseName: 'apps-app',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );

    if (db.missingFeatures.isNotEmpty) {
      print('Using ${db.chosenImplementation} due to unsupported '
          'browser features: ${db.missingFeatures}');
    }

    return db.resolvedExecutor;
  }));
}

Future<void> validateDatabaseSchema(GeneratedDatabase database) async {
  // Unfortunately, validating database schemas only works for native platforms
}