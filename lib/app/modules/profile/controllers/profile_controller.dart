import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app_firebase/app/data/models/recipe_model.dart';

class ProfileController extends GetxController {
  final recipes = <RecipeModel>[].obs;
  final favorites = <RecipeModel>[].obs;
  final isLoading = false.obs;
  final RxMap<int, bool> recipeLikes = <int, bool>{}.obs;
  final RxMap<int, bool> favoriteLikes = <int, bool>{}.obs;

  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  final Rx<String?> profileImageUrl = Rxn<String>();
  final ImagePicker _picker = ImagePicker();
  final storage = FirebaseStorage.instance;
  final isUploading = false.obs;

  final RxString fullName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getUserRecipes();
    getUserFavorites();
    getProfileImage();
    getUserInfo();
  }

  Future<void> getUserRecipes() async {
    try {
      isLoading.value = true;
      final userId = auth.currentUser?.uid;
      if (userId == null) return;

       
      firestore
          .collection('recipes')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .listen((snapshot) {
        recipes.value = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;

          return RecipeModel.fromJson(data);
        }).toList();

        checkRecipeLikes();
      });
    } catch (e) {
      print('Tarifler getirilirken hata: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUserFavorites() async {
    try {
      final userId = auth.currentUser?.uid;
      if (userId == null) return;

      
      firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .snapshots()
          .listen((snapshot) async {
        final List<RecipeModel> favRecipes = [];
        for (var doc in snapshot.docs) {
          final recipeDoc = await firestore
              .collection('recipes')
              .doc(doc['recipeId'] as String)
              .get();
          if (recipeDoc.exists) {
            final data = recipeDoc.data()!;
            data['id'] = recipeDoc.id;
            favRecipes.add(RecipeModel.fromJson(data));
          }
        }
        favorites.value = favRecipes;
        checkFavoriteLikes();
      });
    } catch (e) {
      print('Favoriler getirilirken hata: $e');
    }
  }

  Future<void> checkRecipeLikes() async {
    try {
      final userId = auth.currentUser?.uid;
      if (userId == null) return;

      for (int i = 0; i < recipes.length; i++) {
        final doc = await firestore
            .collection('users')
            .doc(userId)
            .collection('favorites')
            .doc(recipes[i].id)
            .get();
        recipeLikes[i] = doc.exists;
      }
    } catch (e) {
      print('Beğeni kontrolünde hata: $e');
    }
  }

  Future<void> checkFavoriteLikes() async {
    try {
      final userId = auth.currentUser?.uid;
      if (userId == null) return;

      for (int i = 0; i < favorites.length; i++) {
        final doc = await firestore
            .collection('users')
            .doc(userId)
            .collection('favorites')
            .doc(favorites[i].id)
            .get();
        favoriteLikes[i] = doc.exists;
      }
    } catch (e) {
      print('Beğeni kontrolünde hata: $e');
    }
  }

  Future<void> getProfileImage() async {
    try {
      final userId = auth.currentUser?.uid;
      if (userId == null) return;

      final userDoc = await firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null) {
          profileImageUrl.value =
              data['profileImage'] ?? 'assets/images/profile.png';
        }
      }
    } catch (e) {
      print('Profil fotoğrafı getirilirken hata: $e');
    }
  }

  Future<void> updateProfileImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) return;

      final userId = auth.currentUser?.uid;
      if (userId == null) {
        Get.snackbar('Hata', 'Lütfen giriş yapın');
        return;
      }

      
      isUploading.value = true;
     
      profileImageUrl.value = image.path;

      
      final ref = storage.ref().child('profile_images/$userId.jpg');
      await ref.putFile(File(image.path));

       
      final url = await ref.getDownloadURL();

      
      await firestore.collection('users').doc(userId).set({
        'profileImage': url,
      }, SetOptions(merge: true));

      
      final recipesSnapshot = await firestore
          .collection('recipes')
          .where('userId', isEqualTo: userId)
          .get();

      final batch = firestore.batch();
      for (var doc in recipesSnapshot.docs) {
        batch.update(doc.reference, {'authorImage': url});
      }
      await batch.commit();

       
      profileImageUrl.value = url;

      Get.snackbar('Başarılı', 'Profil fotoğrafı güncellendi');
    } catch (e) {
      Get.snackbar('Hata', 'Fotoğraf yüklenirken bir hata oluştu: $e');
    } finally {
      isUploading.value = false;
    }
  }

  void showImageSourceDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Fotoğraf Seç'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera'),
              onTap: () {
                Get.back();
                updateProfileImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () {
                Get.back();
                updateProfileImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getUserInfo() async {
    try {
      final userId = auth.currentUser?.uid;
      if (userId == null) return;

      final userDoc = await firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        fullName.value = '${data['name']} ${data['surname']}';
      }
    } catch (e) {
      print('Kullanıcı bilgileri getirilirken hata: $e');
    }
  }

  Future<void> logout() async {
    try {
      await auth.signOut();
    } catch (e) {
      print('Çıkış yapılırken hata: $e');
      Get.snackbar(
        'Hata',
        'Çıkış yapılırken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
