import 'package:app_english_study/models/el_today.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../value/app_assets.dart';
import '../value/app_colors.dart';
import '../value/app_styles.dart';

class AllWordsPage extends StatelessWidget {
  final List<EnglishToday> words;
  const AllWordsPage({Key? key, required this.words}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondColor,
      body: AnimatedContainer(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: words
              .map((e) => Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.lightGrey,
                          offset: Offset(3, 3),
                          blurRadius: 3,
                        )
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        e.noun.toString(),
                        style: AppStyles.h4,
                        maxLines: 1,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.secondColor,
        elevation: 0,
        // leading: Icon(Image.asset(AppAssets.menu)),
        title: Text(
          'English today',
          style: AppStyles.h4.copyWith(color: Colors.black, fontSize: 36),
        ),
        leading: InkWell(
          onTap: () => {
            Navigator.pop(context),
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(AppAssets.left_arrow),
          ),
        ),
      ),
    );
  }
}
