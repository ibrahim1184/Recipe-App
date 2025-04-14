import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:recipe_app_firebase/app/modules/sign_in/views/custom_mini_circle_widget.dart';
import 'package:recipe_app_firebase/colors.dart';
import 'package:recipe_app_firebase/typography.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../controllers/detail_recipe_controller.dart';

class DetailRecipeView extends GetView<DetailRecipeController> {
  const DetailRecipeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SlidingUpPanel(
            minHeight: context.height * 0.5,
            maxHeight: context.height,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            parallaxEnabled: true,
            parallaxOffset: 0.5,
            body: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: context.height * 0.6,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ),
                  child: Obx(
                    () => controller.recipe.value?.imageUrl != null
                        ? Hero(
                            tag: controller.recipe.value!.id,
                            child: InteractiveViewer(
                              constrained: true,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      controller.recipe.value!.imageUrl!,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const Center(
                            child:
                                Icon(Icons.image, size: 50, color: Colors.grey),
                          ),
                  ),
                ),
                
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).padding.top + 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
            panel: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(12),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 9,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppColors.outline,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const Gap(20),
                    Obx(() {
                      return Text(
                        controller.recipe.value!.title,
                        style: AppTypography.headline2
                            .copyWith(color: const Color(0xFF3E5481)),
                      );
                    }),
                    const Gap(12),
                    Row(
                      children: [
                        Text(
                          "Yemek",
                          style: AppTypography.bodyText2.copyWith(
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
                          ">${controller.recipe.value!.preparationTime} dakika",
                          style: AppTypography.bodyText2.copyWith(
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: controller.recipe.value!.authorImage
                                  .startsWith('http')
                              ? NetworkImage(
                                  controller.recipe.value!.authorImage)
                              : controller.recipe.value!.authorImage
                                      .startsWith('assets/')
                                  ? AssetImage(
                                          controller.recipe.value!.authorImage)
                                      as ImageProvider
                                  : const AssetImage(
                                      "assets/images/profile.png"),
                          radius: 16,
                          child: controller.recipe.value!.authorImage.isEmpty
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
                            controller.recipe.value!.authorName,
                            style: AppTypography.headline3.copyWith(
                              color: const Color(0xFF3E5481),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.toggleFavorite(),
                          child: Obx(() => SvgPicture.asset(
                                controller.isFavorite.value
                                    ? "assets/icons/heart_filled_recipe_detail.svg"
                                    : "assets/icons/heart_recipe_detail.svg",
                                colorFilter: ColorFilter.mode(
                                  controller.isFavorite.value
                                      ? AppColors.primary
                                      : Colors.grey,
                                  BlendMode.srcIn,
                                ),
                                width: 24,
                                height: 24,
                              )),
                        ),
                        const Gap(6),
                        Obx(
                          () => Text(
                            "${controller.likeCount.value} Beğenme",
                            style: AppTypography.headline3.copyWith(
                              color: const Color(0xFF3E5481),
                            ),
                          ),
                        )
                      ],
                    ),
                    const Gap(12),
                    const Divider(
                      color: AppColors.outline,
                      thickness: 1,
                    ),
                    const Gap(12),
                    Text(
                      "Açıklama",
                      style: AppTypography.headline2.copyWith(
                        color: const Color(0xFF3E5481),
                      ),
                    ),
                    const Gap(12),
                    Text(
                      controller.recipe.value!.description,
                      style: AppTypography.bodyText2.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const Gap(12),
                    const Divider(
                      color: AppColors.outline,
                      thickness: 1,
                    ),
                    const Gap(12),
                    Text(
                      "Malzemeler",
                      style: AppTypography.headline2.copyWith(
                        color: const Color(0xFF3E5481),
                      ),
                    ),
                    const Gap(12),
                    ...controller.recipe.value!.ingredients
                        .map((ingredient) => ingredients(text: ingredient)),
                    const Gap(12),
                    const Divider(
                      color: AppColors.outline,
                      thickness: 1,
                    ),
                    const Gap(12),
                    Text(
                      "Adımlar",
                      style: AppTypography.headline2.copyWith(
                        color: const Color(0xFF3E5481),
                      ),
                    ),
                    const Gap(12),
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.recipe.value!.steps.length,
                      itemBuilder: (context, index) {
                        final step = controller.recipe.value!.steps[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            children: [
                              CustomCircleWidget(
                                size: 24,
                                color: const Color(0xFF3E5481),
                                child: Text(
                                  "${index + 1}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const Gap(8),
                              Expanded(
                                child: Text(
                                  step.description,
                                  style: AppTypography.bodyText2.copyWith(
                                    color: AppColors.mainText,
                                  ),
                                  maxLines: null,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row ingredients({required String text}) {
    return Row(
      children: [
        CustomCircleWidget(
          size: 24,
          color: AppColors.primary,
          child: SvgPicture.asset("assets/icons/check_enable.svg"),
        ),
        const Gap(8),
        Text(
          text,
          style: AppTypography.bodyText2.copyWith(
            color: AppColors.mainText,
          ),
        ),
      ],
    );
  }
}
