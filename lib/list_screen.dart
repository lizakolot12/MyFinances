import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/data.dart';

class ListScreen extends ConsumerWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(repositoryProvider);
    return FutureBuilder(
      future: repository.getAll(),
      builder: (_, AsyncSnapshot<List<Transaction>> snapshot) {
        if (snapshot.hasData) {
          var list = snapshot.data;
          return Stack(
            children: [
              ListView.builder(
                itemCount: list?.length ?? 0,
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    list?[index].name ?? '',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    list?[index].total.toString() ?? '',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: IconButton(
                    disabledColor: Colors.black12,
                    icon: const Icon(
                      Icons.delete,
                    ),
                    onPressed: list?[index].isProgress ?? false
                        ? null
                        : () => repository.remove(index),
                  ),
                ),
              ),
              if (snapshot.connectionState == ConnectionState.waiting)
                progress()
            ],
          );
        } else {
          return progress();
        }
      },
    );
  }

  Widget progress() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
