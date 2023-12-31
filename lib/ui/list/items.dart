import 'package:flutter/material.dart';
import 'package:my_study/data/data.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0),
        borderRadius: const BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    transaction.name,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "${transaction.total} грн.",
                  ),
                ),
              ),
            ],
          ),
          if ((transaction.tags?.length ?? 0) > 0)
            Wrap(
              spacing: 4,
              children: [
                for (var i in transaction.tags ?? [])
                  Chip(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    label: Text(
                      i,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class TransactionGridItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionGridItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0),
        borderRadius: const BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      child: Column(children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  transaction.name,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "${transaction.total} грн.",
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.all(4.0),
            child: Text(
              transaction.tags?.join(" ") ?? "",
            ),
          ),
        ),
      ]),
    );
  }
}
