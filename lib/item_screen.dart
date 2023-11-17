import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/data.dart';
import 'data/item_bloc.dart';
import 'edit_screen.dart';

class ItemScreen extends StatelessWidget {
  final int? transactionId;

  const ItemScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => TransactionItemBloc(
          repository: RepositoryProvider.of<TransactionRepository>(context),
        ),
        child: EditScreen(
          transactionId: transactionId,
        ),
    );
  }
}
