import '../datasources/mealdb_api.dart';
import '../datasources/recipes_data.dart';
import '../models/potion.dart';

class PotionRepository {
  // Fetch a single recipe by ID, try API first, fallback to local asset
  Future<Potion?> getPotionById(String id) async {
    try {
      final apiRecipes = await MealDBApi.fetchAllRecipes();
      final potions =
          apiRecipes.map(MealDBMapper.toPotion).where((p) => p.id == id);
      if (potions.isNotEmpty) return potions.first;
    } catch (_) {}
    // Fallback to local asset
    final localPotions = await RecipesDataSource.loadRecipes();
    return localPotions.firstWhere((p) => p.id == id, orElse: () => null);
  }

  // Fetch all potions, try API first, fallback to local asset
  Future<List<Potion>> getAllPotions() async {
    try {
      final apiRecipes = await MealDBApi.fetchAllRecipes();
      final potions = apiRecipes.map(MealDBMapper.toPotion).toList();
      if (potions.isNotEmpty) return potions;
    } catch (_) {}
    // Fallback to local asset
    return await RecipesDataSource.loadRecipes();
  }
}
