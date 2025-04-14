import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:recipe_app_firebase/app/data/models/recipe_model.dart';
import 'package:recipe_app_firebase/app/modules/home/controllers/home_controller.dart';

class DetailRecipeController extends GetxController {
  final recipe = Rxn<RecipeModel>();
  final isFavorite = false.obs;
  final likeCount = 0.obs;
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    recipe.value = Get.arguments as RecipeModel;
    likeCount.value = recipe.value?.likeCount ?? 0;
    checkIfFavorite();
    listenToLikeCount();
  }

  void listenToLikeCount() {
    try {
      firestore
          .collection('recipes')
          .doc(recipe.value!.id)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          likeCount.value = data['likeCount'] ?? 0;
        }
      });
    } catch (e) {
      print('Like count dinlemede hata: $e');
    }
  }

  void checkIfFavorite() async {
    try {
      final userId = auth.currentUser?.uid;
      if (userId == null) return;

      final doc = await firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(recipe.value!.id)
          .get();

      isFavorite.value = doc.exists;
    } catch (e) {}
  }

  void toggleFavorite() async {
    final userId = auth.currentUser!.uid;
    final recipeId = recipe.value!.id;

    try {
      
      final favoriteDoc = await firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(recipeId)
          .get();

      if (favoriteDoc.exists) {
        
        await firestore
            .collection('users')
            .doc(userId)
            .collection('favorites')
            .doc(recipeId)
            .delete();

        
        if (likeCount.value > 0) {
          await firestore
              .collection('recipes')
              .doc(recipeId)
              .update({'likeCount': FieldValue.increment(-1)});
        }

        isFavorite.value = false;
        Get.find<HomeController>().updateFavorite(recipeId, false);
      } else {
         
        await firestore
            .collection('users')
            .doc(userId)
            .collection('favorites')
            .doc(recipeId)
            .set({
          'recipeId': recipeId,
          'userId': userId,
          'addedAt': FieldValue.serverTimestamp(),
        });

        await firestore
            .collection('recipes')
            .doc(recipeId)
            .update({'likeCount': FieldValue.increment(1)});

        isFavorite.value = true;
        Get.find<HomeController>().updateFavorite(recipeId, true);
      }
    } catch (e) {
      Get.snackbar('Hata', "Bir hata oluştu: $e");
    }
  }
}
