import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

class RecipeService {
  static const String _deletedRecipesKey = 'deleted_recipes';

  static Future<void> deleteRecipe(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final deleted = prefs.getStringList(_deletedRecipesKey) ?? [];
    if (!deleted.contains(id)) {
      deleted.add(id);
      await prefs.setStringList(_deletedRecipesKey, deleted);
    }
  }

  static Future<List<String>> getDeletedRecipeIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_deletedRecipesKey) ?? [];
  }

  static List<Recipe> getRecipes() {
    final List<String> images = [
      'assets/3861770815256_.pic_hd.jpg',
      'assets/3871770815257_.pic_hd.jpg',
      'assets/3881770815258_.pic_hd.jpg',
      'assets/3891770815259_.pic_hd.jpg',
      'assets/3901770815260_.pic_hd.jpg',
      'assets/3911770815261_.pic_hd.jpg',
      'assets/3921770815262_.pic_hd.jpg',
      'assets/3931770815263_.pic_hd.jpg',
      'assets/3941770815264_.pic_hd.jpg',
      'assets/3951770815265_.pic_hd.jpg',
      'assets/3961770815266_.pic_hd.jpg',
      'assets/3971770815267_.pic_hd.jpg',
      'assets/3981770815268_.pic_hd.jpg',
      'assets/3991770815269_.pic_hd.jpg',
      'assets/4001770815270_.pic_hd.jpg',
      'assets/4011770815271_.pic_hd.jpg',
      'assets/4021770815271_.pic_hd.jpg',
      'assets/4031770815272_.pic_hd.jpg',
      'assets/4041770815273_.pic_hd.jpg',
      'assets/4051770815274_.pic_hd.jpg',
      'assets/4061770815276_.pic_hd.jpg',
      'assets/4071770815277_.pic_hd.jpg',
      'assets/4081770815278_.pic_hd.jpg',
      'assets/4091770815279_.pic_hd.jpg',
      'assets/4101770815280_.pic_hd.jpg',
      'assets/4111770815280_.pic_hd.jpg',
      'assets/4121770815281_.pic_hd.jpg',
      'assets/4131770815282_.pic_hd.jpg',
    ];

    final List<Recipe> recipes = [];

    // Helper to generate a recipe
    Recipe createRecipe(int index, String imagePath) {
      final id = (index + 1).toString();

      // Rotate through common methods
      final methods = [
        'V60 01',
        'V60 02',
        'Kalita 155',
        'Kalita 185',
        'Aeropress',
        'Origami',
        'Chemex',
      ];
      final brewer = methods[index % methods.length];

      // Rotate through some names/origins
      final names = [
        'Morning Clarity',
        'Afternoon Delight',
        'Ethiopia Guji Flash',
        'Kenya Nyeri AA',
        'Colombia Pink Bourbon',
        'Panama Geisha',
        'Costa Rica Honey',
        'Sumatra Mandheling',
        'Guatemala Antigua',
        'Brazil Cerrado',
        'Honduras Marcala',
        'El Salvador Pacamara',
        'Rwanda Bourbon',
        'Burundi Ngozi',
        'Tanzania Peaberry',
        'Uganda Bugisu',
        'India Monsooned',
        'Papua New Guinea',
        'Vietnam Robusta',
        'Mexico Altura',
        'Peru Chanchamayo',
        'Nicaragua Jinotega',
        'Yemen Mocha',
        'Jamaica Blue Mtn',
        'Hawaii Kona',
        'Galapagos San Cristobal',
        'Nepal Himalayan',
        'Yunnan Catimor',
      ];
      final name = names[index % names.length];

      // Metadata rotation
      final origins = [
        'Ethiopia',
        'Kenya',
        'Colombia',
        'Panama',
        'Costa Rica',
        'Sumatra',
        'Brazil',
      ];
      final origin = origins[index % origins.length];

      final processes = [
        'Washed',
        'Natural',
        'Honey',
        'Anaerobic',
        'Wet Hulled',
      ];
      final process = processes[index % processes.length];

      final roasts = ['Light', 'Medium-Light', 'Medium', 'Medium-Dark', 'Dark'];
      final roast = roasts[index % roasts.length];

      final flavorTags = [
        ['Floral', 'Citrus', 'Tea-like'],
        ['Berry', 'Sweet', 'Juicy'],
        ['Chocolate', 'Nutty', 'Smooth'],
        ['Spicy', 'Earthy', 'Bold'],
        ['Fruity', 'Winey', 'Complex'],
      ];
      final tags = flavorTags[index % flavorTags.length];

      // Generate varied descriptions
      String generateDescription() {
        final intros = [
          "Experience the vibrant character of this $origin bean.",
          "A meticulously crafted recipe for the $name.",
          "This brew highlights the best of $origin coffee.",
          "Discover the hidden nuances of this $process lot.",
          "A classic approach to brewing $origin coffee.",
        ];

        final bodies = [
          "The $process process adds a distinct layer of complexity, while the $roast roast ensures balance.",
          "Expect a cup bursting with ${tags[0].toLowerCase()} notes and a smooth finish.",
          "This recipe emphasizes clarity and sweetness, perfect for the ${tags.join(', ')} flavor profile.",
          "We've dialed in this recipe to showcase its $roast qualities and rich texture.",
          "With a focus on extraction, this method brings out the ${tags[1].toLowerCase()} acidity.",
        ];

        final outros = [
          "Perfect for a focused brewing session.",
          "Best enjoyed without distractions.",
          "Ideal for a slow morning ritual.",
          "A true delight for the senses.",
          "Simple to brew, complex to taste.",
        ];

        return "${intros[index % intros.length]} ${bodies[index % bodies.length]} ${outros[index % outros.length]}";
      }

      // Slight variations in params
      final temp = 88.0 + (index % 10); // 88-97
      final dose = 15 + (index % 6); // 15-20
      final ratio = 15 + (index % 3); // 15, 16, 17
      final water = dose * ratio;

      return Recipe(
        id: id,
        name: name,
        brewer: brewer,
        temp: temp,
        dose: dose,
        water: water,
        grindSetting: 'CMD ${20 + (index % 10)}',
        imagePath: imagePath,
        origin: origin,
        process: process,
        roastLevel: roast,
        flavorTags: tags,
        description: generateDescription(),
        steps: [
          BrewStep(
            description: 'Bloom',
            durationSeconds: 45,
            targetWeight: dose * 3,
          ),
          BrewStep(
            description: 'Pour 1',
            durationSeconds: 45,
            targetWeight: (water * 0.6).round(),
          ),
          BrewStep(
            description: 'Final Pour',
            durationSeconds: 60,
            targetWeight: water,
          ),
        ],
      );
    }

    for (int i = 0; i < images.length; i++) {
      recipes.add(createRecipe(i, images[i]));
    }

    return recipes;
  }
}
