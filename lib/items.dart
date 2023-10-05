import 'package:flutter/material.dart';
import 'data/recipe.dart';

class FullItem extends StatelessWidget {
  final Recipe _recipe;

  const FullItem(this._recipe, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Colors.cyan, Colors.cyanAccent],
          ),
        ),
        child: ClipOval(
          child: Image.asset(
            _recipe.uri,
            fit: BoxFit.cover,
          ),
        ));
  }
}


class SimpleItem extends StatelessWidget {
  final Recipe recipe;

   const SimpleItem({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black12,
        border: Border.all(width: 1.0),
        borderRadius: const BorderRadius.all(Radius.circular(16.0) 
        ),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(48), 
                  child: Image.asset(recipe.uri, fit: BoxFit.cover),
                ),
              )),
          Expanded(
              flex: 3,
              child: Padding(
                  padding: const EdgeInsets.all(16), 
                  child: Text(recipe.name,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.teal,
                      )))),
          Expanded(
              flex: 2,
              child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text("${recipe.duration} хв.",
                      style: const TextStyle(
                        color: Colors.cyan,
                      )))),
        ],
      ),
    );
  }
}
