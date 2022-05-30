import 'package:app_english_study/pages/home_page.dart';
import 'package:app_english_study/value/app_assets.dart';
import 'package:app_english_study/value/app_colors.dart';
import 'package:app_english_study/value/app_font.dart';
import 'package:app_english_study/value/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                  child: Container(
                alignment: Alignment.centerLeft,
                child: Text('Welcome to', style: AppStyles.h3),
              )),
              Expanded(
                  child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('English',
                        style: AppStyles.h2.copyWith(
                            color: AppColors.blackGrey,
                            fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        'Quotes"',
                        style: AppStyles.h4.copyWith(height: 0.6),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
              )),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(bottom: 72),
                child: RawMaterialButton(
                  fillColor: AppColors.lightBlue,
                  shape: CircleBorder(),
                  onPressed: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => HomePage()));
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => HomePage()),
                        (route) => false);
                  },
                  child: Image.asset(AppAssets.right_arrow),
                ),
              )),
            ],
          ),
        ));
  }
}
