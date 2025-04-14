import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:recipe_app_firebase/app/data/models/recipe_model.dart';

class HomeController extends GetxController {
  final selectedCategory = "Tümü".obs;

  final recipes = <RecipeModel>[].obs;
  final isLoading = false.obs;
  final firestore = FirebaseFirestore.instance;
  final RxMap<int, bool> favorites = <int, bool>{}.obs;
  final RxString userName = ''.obs;

  void changeCategory(String category) {
    selectedCategory.value = category;
  }

  void favorite(int index) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        Get.snackbar('Hata', 'Lütfen giriş yapın');
        return;
      }

      final recipe = recipes[index];
      final recipeId = recipe.id;
      final isFavorite = favorites[index] ?? false;

      if (isFavorite) {
        
        await firestore
            .collection('users')
            .doc(userId)
            .collection('favorites')
            .doc(recipeId)
            .delete();

        
        if (recipe.likeCount > 0) {
          await firestore
              .collection('recipes')
              .doc(recipeId)
              .update({'likeCount': FieldValue.increment(-1)});
        }
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
      }

     
      favorites[index] = !isFavorite;
    } catch (e) {
      Get.snackbar('Hata', 'Bir hata oluştu: $e');
    }
  }

   
  Future<void> getRecipes() async {
    try {
      isLoading.value = true;

      
      firestore.collection('recipes').snapshots().listen((querySnapshot) {
        recipes.value = querySnapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return RecipeModel.fromJson(data);
        }).toList();

        
        checkFavorites();
      });
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Tarifler yüklenirken bir hata oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<void> uploadRecipe({
    required String title,
    required String description,
    required String preparationTime,
    required List<String> ingredients,
    required List<RecipeStep> steps,
    String? imageUrl,
  }) async {
    try {
      isLoading.value = true;

     
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        Get.snackbar('Hata', 'Lütfen giriş yapın');
        return;
      }

     
      final userDoc = await firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        Get.snackbar('Hata', 'Kullanıcı bilgileri bulunamadı');
        return;
      }

      final userData = userDoc.data()!;
      final authorName = '${userData['name']} ${userData['surname']}';
      final authorImage =
          userData['profileImage'] ?? 'assets/images/profile.png';

      final recipe = RecipeModel(
        id: '',
        title: title,
        description: description,
        preparationTime: preparationTime,
        ingredients: ingredients,
        steps: steps,
        imageUrl: imageUrl,
        authorName: authorName,
        authorImage: authorImage,
        userId: userId,
        createdAt: DateTime.now(),
      );

      await firestore.collection('recipes').add(recipe.toJson());

      Get.snackbar(
        'Başarılı',
        'Tarif başarıyla yüklendi',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Hata',
        'Tarif yüklenirken bir hata oluştu: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

   
  Future<void> checkFavorites() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      
      for (int i = 0; i < recipes.length; i++) {
        final doc = await firestore
            .collection('users')
            .doc(userId)
            .collection('favorites')
            .doc(recipes[i].id)
            .get();

        favorites[i] = doc.exists;
      }
    } catch (e) {
      print('Favori kontrolünde hata: $e');
    }
  }

  
  void updateFavorite(String recipeId, bool isFavorite) {
    final index = recipes.indexWhere((recipe) => recipe.id == recipeId);
    if (index != -1) {
      favorites[index] = isFavorite;
    }
  }

  void listenToFavorites() {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .snapshots()
          .listen((snapshot) {
        
        for (int i = 0; i < recipes.length; i++) {
          final isLiked = snapshot.docs.any((doc) => doc.id == recipes[i].id);
          favorites[i] = isLiked;
        }
      });
    } catch (e) {
      print('Favori dinlemede hata: $e');
    }
  }

  Future<void> getUserInfo() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      final userDoc = await firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        userName.value = '${data['name']} ${data['surname']}';
      }
    } catch (e) {
      print('Kullanıcı bilgileri getirilirken hata: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    getRecipes();
    checkFavorites();
    listenToFavorites();
    getUserInfo();
  }
}
