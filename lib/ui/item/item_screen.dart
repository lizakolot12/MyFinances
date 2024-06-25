import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_study/bloc/item/item_bloc.dart';
import 'package:my_study/data/data.dart';
import 'package:my_study/ui/item/edit_screen.dart';

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
