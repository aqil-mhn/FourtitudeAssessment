import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fourtitude_assessment/configs/app_database.dart';
import 'package:fourtitude_assessment/modules/screens/recipe_form_screen.dart';
import 'package:sqflite/sqflite.dart';

class RecipeDetailScreen extends StatefulWidget {
  RecipeDetailScreen({super.key, required this.recipe});

  Map<String, dynamic> recipe = {};

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Map<String, dynamic> datasource = {};

  @override
  void initState() {
    super.initState();
    
    init();
  }
  init() async {
    datasource = jsonDecode(widget.recipe['datasource']);
  }

  Future<void> _deleteRecipe() async {
    try {
      final db = await openDatabase(dbPath, version: 1);
      await db.delete(
        'recipes',
        where: 'id = ?',
        whereArgs: [widget.recipe['id']],
      );
      
      // Delete the image file
      final imageFile = File(widget.recipe['imagePath']);
      if (await imageFile.exists()) {
        await imageFile.delete();
      }
      
    } catch (e) {
      print('Error deleting recipe: $e');
    }
  }

  Future<void> _showDeleteConfirmation() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Recipe'),
          content: Text('Are you sure you want to delete this recipe?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteRecipe();
                Navigator.of(context).pop(true); // Close dialog
                Navigator.of(context).pop(true); // Return to previous screen
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 98, 124, 119),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Recipe Detail",
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Image Section
                Container(
                  height: 300,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10)
                    ),
                    child: Image.file(
                      File(widget.recipe['imagePath']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                // Content Section
                Positioned(
                  left: 0,
                  right: 0,
                  top: 250,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                        bottom: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.recipe['name'] ?? '-',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            _buildContainerTag(datasource['strCategory']),
                            SizedBox(
                              width: 10,
                            ),
                            _buildContainerTag(datasource['strArea']),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => RecipeFormScreen(
                                        isUpdate: true,
                                        data: widget.recipe,
                                      ),
                                    ),
                                  ).then((value) {
                                    if (value == true) {
                                      init();
                                    }
                                  });
                                },
                                child: Text(
                                  'Update',
                                  style: TextStyle(
                                    color: Colors.black
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              flex: 1,
                              child: OutlinedButton(
                                style: ButtonStyle(
                                  side: WidgetStateProperty.all(BorderSide(
                                    color: Colors.red
                                  )),
                                  backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 245, 205, 205))
                                ),
                                onPressed: () {
                                  _showDeleteConfirmation();
                                },
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.red
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                        // Add more recipe details here
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildContainerTag(String title) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey
      ),
      child: Text(
        title.toString().toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),
      ),
    );
  }
}