class Recipe {
  final String _name;
  final String _uri;
  final int _duration;

  Recipe(this._name, this._uri, this._duration);

  String get uri => _uri;

  int get duration => _duration;

  String get name => _name;
}

class RecipeRepository {
  final List<Recipe> _recipes = [];

  List<Recipe> getAll() {
    return _recipes;
  }

  RecipeRepository() {
    _recipes.add(Recipe("Торт", "assets/images/cake.png", 200));
    _recipes.add(Recipe("Риба", "assets/images/fish.jpg", 120));
    _recipes.add(Recipe("Котлети", "assets/images/meat.jpeg", 40));
    _recipes.add(Recipe("Салат", "assets/images/salad.jpg", 20));
  }
}
