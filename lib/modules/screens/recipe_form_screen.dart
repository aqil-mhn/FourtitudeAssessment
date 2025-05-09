import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RecipeFormScreen extends StatefulWidget {
  RecipeFormScreen({super.key, required this.data, required this.isUpdate});

  bool isUpdate = false;
  Map<String, dynamic> data = {};

  @override
  State<RecipeFormScreen> createState() => _RecipeFormScreenState();
}

class _RecipeFormScreenState extends State<RecipeFormScreen> {
  final ImagePicker _picker = ImagePicker();
  final ValueNotifier<bool> _isUpdate = ValueNotifier<bool>(false);
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  String imageData = '';
  Map<String, dynamic> recipeData = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _isUpdate.value = widget.isUpdate;

    if (widget.data.isNotEmpty) {
      recipeData = Map<String, dynamic>.from(widget.data);
      imageData = recipeData['imagePath'];
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final File fileImage = File(image.path);
      final bytes = await fileImage.readAsBytes();
      final String base64Image = base64Encode(bytes);

      // isImageEdit = true;

      setState(() {
        imageData = base64Image;
        recipeData['imagePath'] = image.path;
      });
    } else {
      // isImageEdit = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 243, 241),
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
          "Recipe Form",
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ValueListenableBuilder(
              valueListenable: _isUpdate,
              builder: (context, isUpdate, child) {
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              height: isUpdate ? null : null,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 231, 231, 231),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: isUpdate ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  child: Image.file(File(recipeData['imagePath'])),
                                ),
                              ) : imageData.isEmpty ? Center(
                                child: IconButton(
                                  onPressed: () {
                                    _pickImage();
                                  },
                                  iconSize: 45,
                                  icon: Icon(
                                    Icons.add_a_photo_outlined,
                                  ),
                                ),
                              ) : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  child: Image.memory(base64Decode(imageData)),
                                ),
                              )
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (recipeData['imagePath'] != null)
                            OutlinedButton(
                              onPressed: () {
                                _pickImage();
                              },
                              child: Text(
                                "Edit Image"
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('Name'),
                            TextFormField(
                              controller: nameController,
                              style: TextStyle(fontSize: 14),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter recipe name";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                labelStyle: TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(width: 0.5)
                                ),
                                floatingLabelStyle: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}