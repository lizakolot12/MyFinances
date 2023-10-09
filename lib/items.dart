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
        color: Colors.black12,
        border: Border.all(width: 1.0),
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      ),
      child: Column(children: [
        Row(
          children: [
            Expanded(
                flex: 3,
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(transaction.name,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.teal,
                        )))),
            Expanded(
                flex: 2,
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text("${transaction.total} грн.",
                        style: const TextStyle(
                          color: Colors.cyan,
                        )))),
          ],
        ),
        Wrap(
          spacing: 8,
          children: [
            for (var i in transaction.tags ?? [])
              Chip(
                  backgroundColor: Color(0xFFE1E4F3),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  label: Text(
                    i,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF072AD7)),
                  )),
          ],
        ),
      ]),
    );
  }
}
