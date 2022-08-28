import 'package:amazonclone/constants/global_variables.dart';
import 'package:amazonclone/routes/router.dart';
import 'package:flutter/material.dart';

class TopCategories extends StatelessWidget {
  const TopCategories({super.key});

  void navigateToCategoryPage(BuildContext context, String category) {
    Navigator.pushNamed(context, categoryDeals, arguments: category);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: 60,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: GlobalVariables.categoryImages.length,
          itemExtent: size.width / (GlobalVariables.categoryImages.length),
          itemBuilder: (c, index) {
            Map cate = GlobalVariables.categoryImages[index];
            return GestureDetector(
              onTap: () {
                navigateToCategoryPage(context, cate["title"]);
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        50,
                      ),
                      child: Image.asset(
                        cate["image"],
                        fit: BoxFit.cover,
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ),
                  Text(
                    cate["title"],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
