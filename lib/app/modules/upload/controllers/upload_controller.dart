import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UploadController extends GetxController {
  final Rxn<File> selectedImage = Rxn<File>();
  final ImagePicker imagePicker = ImagePicker();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final RxInt cookingTime = 30.obs;
  final RxInt step = 1.obs;
  final tempTitle = RxString("");
  final tempDescription = RxString("");
  final tempPreparationTime = RxString("");
  final tempImage = Rxn<File>();
  final storage = FirebaseStorage.instance;
  final tempImageUrl = RxString("");
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar("Resim seçilirken hata oluştu", e.toString());
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image =
          await imagePicker.pickImage(source: ImageSource.camera);
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar("Resim seçilirken hata oluştu", e.toString());
    }
  }

  void showImageSourceDialog() {
    Get.defaultDialog(
      title: "Resim seç",
      content: Column(
        children: [
          TextButton(
            onPressed: () {
              pickImageFromGallery();
              Get.back();
            },
            child: const Text("Galeri"),
          ),
          TextButton(
            onPressed: () {
              pickImageFromCamera();
              Get.back();
            },
            child: const Text("Kamera"),
          ),
        ],
      ),
    );
  }

  void validateAndContinue() async {
    if (selectedImage.value == null) {
      Get.snackbar("Resim seçilmedi", "Lütfen bir resim seçiniz");
      return;
    }
    if (nameController.text.isEmpty) {
      Get.snackbar("Tarif adı boş olamaz", "Lütfen bir tarif adı giriniz");
      return;
    }
    if (descriptionController.text.isEmpty) {
      Get.snackbar("Açıklama boş olamaz", "Lütfen bir açıklama giriniz");
      return;
    }
     // Önce resmi yükle
  final imageUrl = await uploadImage(selectedImage.value!);
  if (imageUrl == null) return;   

    //Geçici verileri kaydet
    saveTempData();
    tempImageUrl.value = imageUrl;
    Get.toNamed('/upload-step2');
  }

  void saveTempData() {
    tempTitle.value = nameController.text;
    tempDescription.value = descriptionController.text;
    tempPreparationTime.value = cookingTime.value.toString();
    tempImage.value = selectedImage.value;
  }

   Future<String?> uploadImage(File imageFile) async {
    try {
      
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      
      
      final storageRef = storage.ref().child('recipe_images/$fileName.jpg');
      
      
      await storageRef.putFile(imageFile);
      
       
      final downloadUrl = await storageRef.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      Get.snackbar('Hata', 'Resim yüklenirken bir hata oluştu');
      return null;
    }
  }
}
 