import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fourtitude_assessment/commons/string_casing.dart';
import 'package:fourtitude_assessment/configs/app_database.dart';
import 'package:fourtitude_assessment/modules/logins/login_screen.dart';
import 'package:fourtitude_assessment/modules/services/firebase_auth_services.dart';
import 'package:fourtitude_assessment/modules/services/recipes_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ValueNotifier<bool> _isLoading = ValueNotifier<bool>(true);
  FirebaseAuthServices auth = FirebaseAuthServices();
  
  List<Map<String, dynamic>> recipes = [];
  Map<String, dynamic> featuredRecipe = {};

  @override
  void initState() {
    super.initState();
    
    init();
  }

  void init() async {
    _isLoading.value = true;
    try {
      await getRecipes();
      await initLDB();
    } catch (e) {
      log("Get Recipes Error >>> ${e.toString()}");
    } finally {
      _isLoading.value = false;
    }
  }

  initLDB() async {
    recipes = [];
    var db = await openDatabase(
      dbPath,
      version: 1
    );

    recipes = await db.query("recipes");
    if (recipes.isNotEmpty) {
      final random = math.Random();
      final randomIndex = random.nextInt(recipes.length);
      featuredRecipe = recipes[randomIndex];
    }
  }

  Future<void> handleSignOut() async {
    auth.signOut();

    var prefs = await SharedPreferences.getInstance();
    prefs.remove("isUserLoggedIn");
    prefs.remove("userUID");

    // Remove all routes and navigate to LoginScreen
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false, // This removes all routes from the stack
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 243, 241),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 98, 124, 119),
        title: Text(
          "Recipe App",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              handleSignOut();
            },
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Image.asset(
            "assets/images/recipe_icon.png",
            width: 10,
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: _isLoading,
        builder: (context, value, child) {
          if (value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: const Color.fromARGB(255, 98, 124, 119),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Downloading recipes"
                  )
                ],
              ),
            );
          }
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10)
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 98, 124, 119)
                  ),
                  height: 250.0,
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 45,
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: SearchBar(
                          onTap: () {
                  
                          },
                          hintText: "Search recipe",
                          trailing: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Icon(
                                Icons.search
                              ),
                            )
                          ],
                          shadowColor: WidgetStatePropertyAll(
                              Color.fromARGB(0, 63, 60, 51)),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Featured Recipe of The Day",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        elevation: 4,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      // borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Image.file(
                                      File('${featuredRecipe['imagePath']}'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${featuredRecipe['name']?.toString().toUpperCase() ?? "-"}",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 98, 124, 119)
                                      ),
                                    ),
                                    Text(
                                      "${featuredRecipe['type']?.toString().toTitleCase() ?? "-"}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey
                                      ),
                                    ),
                                    Text(
                                      "Main Ingredient:",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal
                                      ),
                                    ),
                                    Text(
                                      _formatIngredients(jsonDecode(featuredRecipe['datasource'])),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "List of Recipes",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10
                              ),
                              itemCount: recipes.length,
                              itemBuilder: (context, index) {
                                final recipe = recipes[index];
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  elevation: 4,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(10)
                                            ),
                                            child: Image.file(
                                              File('${recipe['imagePath']}'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${recipe['name']?.toString().toUpperCase() ?? '-'}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color.fromARGB(255, 98, 124, 119)
                                                ),
                                              ),
                                              Text(
                                                "${recipe['type']?.toString().toTitleCase() ?? '-'}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        },
      )
    );
  }

  String _formatIngredients(Map<String, dynamic> recipe) {
    final ingredients = [
      recipe['strIngredient1']?.toString(),
      recipe['strIngredient2']?.toString(),
      recipe['strIngredient3']?.toString(),
      recipe['strIngredient4']?.toString(),
    ];
    
    // Filter out null or empty ingredients and format them
    final validIngredients = ingredients
        .where((ing) => ing != null && ing.isNotEmpty)
        .map((ing) => ing!.toTitleCase())
        .toList();
        
    return validIngredients.isEmpty ? '-' : validIngredients.join(', ');
  }
}