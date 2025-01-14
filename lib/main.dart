import 'dart:io'; // Import do sprawdzania platformy
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Import sqflite_ffi
import 'providers/auth_provider.dart';
import 'providers/task_provider.dart';
import 'services/database_service.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicjalizacja sqflite_common_ffi dla platform desktopowych
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi; // Ustawienie fabryki bazy danych
  }

  await printDatabasePath(); // Wywołanie funkcji do wydrukowania ścieżki bazy danych
  runApp(const TaskManagerApp());
}

Future<void> printDatabasePath() async {
  final databasePath = await DatabaseService.instance.database;
  print('Ścieżka do bazy danych: ${databasePath.path}');
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Manager',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const LoginScreen(),
      ),
    );
  }
}
