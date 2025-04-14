import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../colors.dart';
import '../../../../typography.dart';
import '../controllers/home_controller.dart';

class CardWidget extends GetView<HomeController> {
  final int index;
  final bool hideUserInfo;

  const CardWidget({
    super.key,
    required this.index,
    this.hideUserInfo = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final recipe = controller.recipes[index];
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        color: Colors.white,
        width: screenWidth * 0.45,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!hideUserInfo)
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: recipe.authorImage.startsWith('http')
                        ? NetworkImage(recipe.authorImage)
                        : recipe.authorImage.startsWith('assets/')
                            ? AssetImage(recipe.authorImage) as ImageProvider
                            : const AssetImage("assets/images/profile.png"),
                    radius: 16,
                    child: recipe.authorImage.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                  const Gap(12),
                  Expanded(
                    child: Text(
                      recipe.authorName,
                      style: AppTypography.smallText.copyWith(
                        color: AppColors.mainText,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            if (!hideUserInfo) const Gap(12),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  SizedBox(
                    height: screenHeight * 0.13,
                    width: double.infinity,
                    child: recipe.imageUrl != null
                        ? Image.network(
                            recipe.imageUrl!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.error),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.image),
                          ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () => controller.favorite(index),
                      child: Obx(() => ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                width: 35,
                                height: 35,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: (controller.favorites[index] ?? false)
                                      ? AppColors.primary.withOpacity(0.8)
                                      : Colors.black.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: SvgPicture.asset(
                                  "assets/icons/heart.svg",
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ),
                  )
                ],
              ),
            ),
            const Gap(6),
            Text(
              recipe.title,
              style: AppTypography.headline3.copyWith(
                color: AppColors.mainText,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const Gap(6),
            Row(
              children: [
                Text(
                  "Yemek",
                  style: AppTypography.smallText.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: CircleAvatar(
                    radius: 2,
                    backgroundColor: AppColors.secondaryText,
                  ),
                ),
                Text(
                  ">${recipe.preparationTime} dakika",
                  style: AppTypography.smallText.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
