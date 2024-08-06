import 'package:debty/src/app/features/debts_home.dart';
import 'package:debty/src/core/data/debts/debt_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await DebtService.initializeIsar();
  runApp(ChangeNotifierProvider(
      create: (context)=>DebtService(),
      child: const DebtyApp()));
}

class DebtyApp extends StatelessWidget {
  const DebtyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
     MaterialApp(
       title: 'Debty',
       debugShowCheckedModeBanner: false,
       theme: ThemeData(

         colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink.withOpacity(0.5)),
         useMaterial3: true,
       ),
       home: const DebtHome(),
    );
  }
}
