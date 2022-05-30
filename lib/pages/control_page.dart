import 'package:app_english_study/value/app_colors.dart';
import 'package:app_english_study/value/share_key.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../value/app_assets.dart';
import '../value/app_styles.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({Key? key}) : super(key: key);

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  double sliderValue = 5;
  late SharedPreferences prefs;
  @override
  void initState() {
    initDefaultValue();
    super.initState();
  }

  initDefaultValue() async {
    prefs = await SharedPreferences.getInstance();
    int value = prefs.getInt(ShareKeys.counter) ?? 5;
    setState(() {
      sliderValue = value.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondColor,
        elevation: 0,
        // leading: Icon(Image.asset(AppAssets.menu)),
        title: Text(
          'Your control',
          style: AppStyles.h4.copyWith(color: Colors.black, fontSize: 36),
        ),
        leading: InkWell(
          onTap: () async {
            prefs = await SharedPreferences.getInstance();

            await prefs.setInt(ShareKeys.counter, sliderValue.toInt());
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(AppAssets.left_arrow),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Spacer(),
            Text(
              'How much a number word at once?',
              style: AppStyles.h5.copyWith(color: AppColors.lightGrey),
            ),
            Spacer(),
            Text(
              '${sliderValue.toInt()}',
              style: AppStyles.h1.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 144),
            ),
            Spacer(),
            Slider(
              value: sliderValue,
              min: 5,
              max: 100,
              divisions: 96,
              onChanged: (value) {
                setState(() {
                  sliderValue = value;
                });
              },
              // thumbColor: AppColors.primaryColor,
              activeColor: AppColors.primaryColor,
              // inactiveColor: AppColors.primaryColor,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Slide to set',
                style: AppStyles.h5.copyWith(color: AppColors.textColor),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
