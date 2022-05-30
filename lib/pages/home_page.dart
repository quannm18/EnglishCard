import 'dart:convert';
import 'dart:math';

import 'package:app_english_study/models/el_today.dart';
import 'package:app_english_study/packages/quotes/quote_model.dart';
import 'package:app_english_study/pages/all_page.dart';
import 'package:app_english_study/pages/all_world_page.dart';
import 'package:app_english_study/pages/control_page.dart';
import 'package:app_english_study/value/app_assets.dart';
import 'package:app_english_study/value/app_colors.dart';
import 'package:app_english_study/value/app_font.dart';
import 'package:app_english_study/value/app_styles.dart';
import 'package:app_english_study/value/share_key.dart';
import 'package:app_english_study/widgets/app_buttons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:http/http.dart' as http;
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Quote> _quoteList = [];
  String _randomQuote = "";
  int _currentIndex = 0;
  late PageController _pageController;
  List<EnglishToday> words = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void printWarning(String text) {
    print('\x1B[33m$text\x1B[0m');
  }

  void printError(String text) {
    print('\x1B[31m$text\x1B[0m');
  }

  List<int> fixedRandomList({int length = 1, int max = 120, int min = 1}) {
    if (length > max || length < min) {
      return [];
    }
    List<int> newList = [];
    Random random = new Random();
    int count = 1;
    while (count <= length) {
      int val = random.nextInt(max);
      if (newList.contains(val)) {
        continue;
      } else {
        newList.add(val);
        count++;
      }
    }
    return newList;
  }

  void getQuotes(String query) async {
    List<Quote> _quoteFixed = [];
    String url = 'https://quotable.io/search/quotes?query=$query&limit=1';
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);
    var jsonListQuote = jsonData['results'];
    if (jsonListQuote.length == 0) {
      Quote _quote = await Quote(
          author: 'Quan Ngo',
          description:
              '${query.substring(0, 1).toUpperCase()}${query.substring(1, query.length)} is the best word.');
      setState(() {
        _quoteList.add(_quote);
        // printError(_quoteList.length.toString());
      });
    } else {
      for (var i = 0; i < jsonListQuote.length; i++) {
        Quote _quote = await Quote(
            author: jsonListQuote[i]['author'],
            description: jsonListQuote[i]['content']);
        setState(() {
          _quoteList.add(_quote);
          // printError(_quoteList.length.toString());
        });
        // printError(_quoteList.length.toString());
      }
    }
    sortQuoteList();
  }

  sortQuoteList() {
    List<Quote> _sortQuoteFixed = List.filled(words.length,
        Quote(author: 'Quan Ngo', description: 'It is the best word.'));

    if (_quoteList.length >= 5) {
      for (var i = 0; i < _quoteList.length; i++) {
        String _des = _quoteList[i].description.toString();
        for (var j = 0; j < words.length; j++) {
          if (_des
              .toLowerCase()
              .contains(words[j].noun!.toLowerCase().toString())) {
            _sortQuoteFixed[j] = _quoteList[i];
            printError(_sortQuoteFixed[j].description.toString() +
                " - " +
                words[j].noun.toString());
          }
        }
      }
      setState(() {
        for (var i = 0; i < _sortQuoteFixed.length; i++) {
          _quoteList[i] = _sortQuoteFixed[i];
        }
      });
    }
  }

  getRandomQuote() async {
    String url = 'https://api.quotable.io/random';
    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if (jsonData['content'] == null) {
      String randomQuote =
          'It is amazing how complete is the delusion that beauty is goodness.';
      setState(() {
        _randomQuote = randomQuote;
      });
    } else {
      String randomQuote = jsonData['content'];
      setState(() {
        _randomQuote = randomQuote;
      });
    }
  }

  getEnglishToday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int len = prefs.getInt(ShareKeys.counter) ?? 5;
    List<String> newList = [];
    List<int> randomList = fixedRandomList(length: len, max: nouns.length);

    setState(() {
      randomList.forEach((index) {
        newList.add(nouns[index]);
        getQuotes(nouns[index]);
      });
      words = newList
          .map((e) => EnglishToday(
                noun: e,
              ))
          .toList();
    });
  }

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.92);
    super.initState();
    getEnglishToday();
    getRandomQuote();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.secondColor,
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
            _scaffoldKey.currentState?.openDrawer(),
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(AppAssets.menu),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(right: 16, left: 16),
                alignment: Alignment.centerLeft,
                // padding: const EdgeInsets.all(16.0),
                height: size.height * 1 / 10,
                child: Text(
                  '“${_randomQuote}.”',
                  style: AppStyles.h5
                      .copyWith(color: AppColors.textColor, fontSize: 12),
                ),
              ),
              // ignore: sized_box_for_whitespace
              Container(
                height: size.height * 2 / 3,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) => {
                    setState(() => _currentIndex = index),
                  },
                  itemBuilder: (context, index) {
                    String firstLetter =
                        words[index].noun != null ? words[index].noun! : '';
                    firstLetter = firstLetter.substring(0, 1).toUpperCase();

                    String leftLetter =
                        words[index].noun != null ? words[index].noun! : '';
                    leftLetter = leftLetter.substring(1, leftLetter.length);

                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                        color: AppColors.primaryColor,
                        elevation: 4,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          onDoubleTap: () {
                            setState(() {
                              words[index].isFavorite =
                                  !words[index].isFavorite;
                            });
                          },
                          splashColor: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: index >= 5
                                ? InkWell(
                                    child: buildCardShowMore(),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => AllPage(
                                                    words: words,
                                                    quotes: _quoteList,
                                                  )));
                                    },
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      LikeButton(
                                        onTap: (bool isLiked) async {
                                          setState(() {
                                            words[index].isFavorite =
                                                !words[index].isFavorite;
                                          });
                                          return words[index].isFavorite;
                                        },
                                        isLiked: words[index].isFavorite,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        padding: const EdgeInsets.only(
                                            right: 8, top: 16),
                                        size: 42,
                                        circleColor:const CircleColor(
                                            start: Colors.red,
                                            end: Colors.redAccent),
                                        bubblesColor: const BubblesColor(
                                          dotPrimaryColor: Colors.red,
                                          dotSecondaryColor: Colors.redAccent,
                                        ),
                                        likeBuilder: (bool isLiked) {
                                          return Icon(
                                            Icons.favorite,
                                            color: isLiked
                                                ? Colors.red
                                                : Colors.white,
                                            size: 42,
                                          );
                                        },
                                        // likeCount: 665,
                                      ),
                                      // Container(
                                      //   padding: const EdgeInsets.only(
                                      //       right: 8, top: 16),
                                      //   alignment: Alignment.centerRight,
                                      //   child: Image.asset(
                                      //     AppAssets.heart2x,
                                      //     width: 42,
                                      //     height: 42,
                                      //     color: words[index].isFavorite
                                      //         ? Colors.red
                                      //         : Colors.white,
                                      //   ),
                                      // ),
                                      RichText(
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(
                                              text: firstLetter,
                                              style: AppStyles.h2.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [
                                                    BoxShadow(
                                                        color:
                                                            AppColors.lightGrey,
                                                        blurRadius: 6,
                                                        offset: Offset(3, 3)),
                                                  ]),
                                              children: [
                                                TextSpan(
                                                    text: leftLetter,
                                                    style: TextStyle(shadows: [
                                                      Shadow(
                                                          offset: Offset(0, 0)),
                                                    ], fontSize: 56)),
                                              ])),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 24, right: 8, left: 8),
                                        child: AutoSizeText(
                                          '“${_quoteList.length == 0 ? '' : _quoteList[index].description}”',
                                          maxLines: 8,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyles.h4.copyWith(
                                              letterSpacing: 1,
                                              color: AppColors.textColor),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Container(
                                        // padding: const EdgeInsets.only(top: 24),
                                        width: size.width,
                                        child: Text(
                                          '-${_quoteList.length == 0 ? '' : _quoteList[index].author}-',
                                          maxLines: 8,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyles.h4.copyWith(
                                              letterSpacing: 1,
                                              color: AppColors.textColor),
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: words.length > 5 ? 6 : words.length,
                ),
              ),
              //indicator
              _currentIndex >= 5
                  ? buildShowMore()
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      height: 12,
                      alignment: Alignment.center,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        // itemCount: words.length,
                        itemBuilder: (context, index) =>
                            buildIndicator(index == _currentIndex, size),
                      ),
                    )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          setState(() {
            getEnglishToday();
            getRandomQuote();
            _quoteList.clear();
            for (var i = 0; i < words.length; i++) {
              getQuotes(words[i].noun.toString());
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(AppAssets.update),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: AppColors.lightBlue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 42.0, left: 16),
                child: Text(
                  'Your mind',
                  style: AppStyles.h3.copyWith(color: AppColors.textColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: AppButton(
                  label: 'Favorites',
                  onTap: () {
                    printWarning("text");
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: AppButton(
                  label: 'Your control',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ControlPage()));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIndicator(bool isActive, Size size) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      width: isActive ? size.width * 1 / 5 : 24,
      decoration: BoxDecoration(
          color: isActive ? AppColors.lightBlue : AppColors.lightGrey,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
                color: Colors.black38, offset: Offset(2, 3), blurRadius: 3)
          ]),
    );
  }

  Widget buildShowMore() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      alignment: Alignment.centerLeft,
      child: Material(
        elevation: 3,
        color: AppColors.primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AllWordsPage(words: this.words)));
          },
          splashColor: AppColors.lightBlue,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text(
              'Show more',
              style: AppStyles.h6
                  .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCardShowMore() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Text(
        'Show more',
        textAlign: TextAlign.center,
        style: AppStyles.h3.copyWith(fontWeight: FontWeight.bold, shadows: [
          BoxShadow(color: Colors.black26, offset: Offset(3, 3), blurRadius: 3)
        ]),
      ),
    );
  }
}
