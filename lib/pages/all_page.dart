import 'package:app_english_study/models/el_today.dart';
import 'package:app_english_study/packages/quotes/quote_model.dart';
import 'package:flutter/material.dart';

import '../value/app_assets.dart';
import '../value/app_colors.dart';
import '../value/app_styles.dart';

class AllPage extends StatelessWidget {
  final List<EnglishToday> words;
  final List<Quote> quotes;
  const AllPage({Key? key, required this.words, required this.quotes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondColor,
        elevation: 0,
        // leading: Icon(Image.asset(AppAssets.menu)),
        title: Text(
          'All words',
          style: AppStyles.h4.copyWith(color: Colors.black, fontSize: 36),
        ),
        leading: InkWell(
          onTap: () => {Navigator.pop(context)},
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(AppAssets.left_arrow),
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: words.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: (index % 2 == 0)
                      ? AppColors.lightBlue
                      : AppColors.primaryColor),
              child: ListTile(
                title: Text(
                  words[index].noun.toString(),
                  style: (index % 2 != 0)
                      ? AppStyles.h4.copyWith(fontWeight: FontWeight.bold)
                      : AppStyles.h4.copyWith(
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold),
                ),
                leading: Icon(Icons.favorite,
                    color: words[index].isFavorite ? Colors.red : Colors.white),
                subtitle: Text(quotes[index].description.toString(),
                    style: (index % 2 != 0)
                        ? AppStyles.h5
                        : AppStyles.h5.copyWith(color: AppColors.textColor)),
              ),
            );
          }),
    );
  }
}
