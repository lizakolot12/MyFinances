import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/data.dart';
import 'items.dart';
import 'theme_extensions.dart';

class ListScreen extends ConsumerWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(repositoryProvider);
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          stretch: true,
          stretchTriggerOffset: 100.0,
          expandedHeight: 100.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              AppLocalizations.of(context)!.mainDesription,
              style: Theme.of(context).mySpecialTextStyle,
            ),
            background: Image.asset(
              "assets/images/cake.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  repository.remove(repository.getAll()[index]);
                },
                child: TransactionItem(
                  transaction: repository.getAll()[index],
                  key: UniqueKey(),
                ),
              );
            },
            childCount: repository.getAll().length,
          ),
        )
      ],
    );
  }
}
