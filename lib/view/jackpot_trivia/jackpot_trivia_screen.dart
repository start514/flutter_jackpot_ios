import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterjackpot/dialogs/get_categories_dialogs.dart';
import 'package:flutterjackpot/dialogs/game_rules_dialogs.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/common/common_sizebox_addmob.dart';
import 'package:flutterjackpot/utils/image_utils.dart';
import 'package:flutterjackpot/utils/url_utils.dart';
import 'package:flutterjackpot/view/jackpot_trivia/get_quiz_model.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_categories_controller.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_triva_details_screen.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_trivia_categories_model.dart';

class JackPotTriviaScreen extends StatefulWidget {
  @override
  _JackPotTriviaScreenState createState() => _JackPotTriviaScreenState();
}

class _JackPotTriviaScreenState extends State<JackPotTriviaScreen> {
  JackpotCategoriesAndQuizController jackpotCategoriesController =
      new JackpotCategoriesAndQuizController();

  final searchController = new TextEditingController();

  List<Categories>? categories;
  List<Quiz>? quiz;
  List<Quiz> searchQuiz = [];

  String? searchWord;
  bool isSearch = false;

  bool _isLoading = true;
  double unitHeightValue = 1;
  double unitWidthValue = 1;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchWord = searchController.text;
        buildSearchList();
      });
    });
    getQuiz();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
     unitWidthValue = MediaQuery.of(context).size.width * 0.0021;
    return Stack(
      children: [
        bgImage(context),
        Scaffold(
          backgroundColor: transparentColor,
          body: _isLoading
              ? Center(
                  child: CupertinoActivityIndicator(
                    radius: 15.0,
                  ),
                )
              : _bodyWidget(quiz, categories!),
        ),
      ],
    );
  }

  Widget _bodyWidget(List<Quiz>? quiz, List<Categories> categories) {
    return categories.length == 0
        ? Center(
            child: Text(
              "Jackpot Trivia Not Available Now",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ),
          )
        : SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all( unitHeightValue * 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    sizedBoxAddMob(unitHeightValue * 42.0),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: unitHeightValue * 45.0,
                            width: unitWidthValue * 100,
                            child: RaisedButton(
                              child: Icon(
                                Icons.arrow_back_outlined,
                                color: greenColor,
                                size: unitHeightValue * 24.0,
                                semanticLabel:
                                    'Text to announce in accessibility modes',
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              color: blackColor,
                              textColor: blackColor,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: greenColor, width: unitWidthValue * 2.0),
                                borderRadius: BorderRadius.circular(29.5),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: unitWidthValue * 5,
                          ),
                          Expanded(
                            child: Container(
                              // width: unitWidthValue * double.infinity,
                              padding: EdgeInsets.all(unitHeightValue * 8.0),
                              decoration: BoxDecoration(
                                color: blackColor,
                                border: Border.all(
                                  color: greenColor,
                                  width: unitWidthValue * 2,
                                ),
                                borderRadius: BorderRadius.circular(unitHeightValue*15.0),
                              ),
                              child: Text(
                                "JACKPOT TRIVIA",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: unitHeightValue * 26.0,
                                    color: whiteColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: unitWidthValue * 5,
                          ),
                          SizedBox(
                            height: unitHeightValue * 45.0,
                            width: unitWidthValue * 100,
                            child: RaisedButton(
                              child: Text(
                                "RULES",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: whiteColor,
                                    fontSize: unitHeightValue * 20),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      GameRulesDialog(categories),
                                );
                              },
                              padding: EdgeInsets.all(0),
                              color: blackColor,
                              textColor: blackColor,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: greenColor, width: unitWidthValue * 2.0),
                                borderRadius: BorderRadius.circular(unitHeightValue*10),
                              ),
                            ),
                          ),
                        ]),
                    _gridView(),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _gridView() {
    if (quiz!.length == 0) {
      return Padding(
        padding: EdgeInsets.only(top: unitHeightValue * 20.0),
        child: Text(
          "No Record Yet",
          style: TextStyle(
            fontSize: unitHeightValue * 17.0,
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (searchWord != null && searchQuiz.length == 0) {
      return Padding(
        padding: EdgeInsets.only(top: unitHeightValue * 20.0),
        child: Text(
          "No Quiz Matched Your Search",
          style: TextStyle(
            fontSize: unitHeightValue * 17.0,
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: MediaQuery.of(context).size.width / 2),
      itemCount: searchQuiz.length,
      itemBuilder: (BuildContext context, int position) {
        Quiz _quiz = searchQuiz[position];
        return Container(
          padding: EdgeInsets.all(unitHeightValue * 5.0),
          child: InkWell(
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(0.0),
                  margin: EdgeInsets.symmetric(vertical: unitHeightValue * 10.0),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border.all(
                      color: blackColor,
                      width: unitWidthValue * 1.5,
                    ),
                    borderRadius: BorderRadius.circular(unitHeightValue * 29.5),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(unitHeightValue * 16.0),
                      border: Border.all(
                        color: whiteColor,
                        width: unitWidthValue * 1.5,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                          UrlQuizImageJackpotTriviaPrefixUrl +
                              _quiz.photoThumb!,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: unitWidthValue * 60.0,
                    margin: EdgeInsets.fromLTRB(unitWidthValue * 10, unitHeightValue * 20, 0, 0),
                    padding: EdgeInsets.all(unitHeightValue * 2.0),
                    decoration: BoxDecoration(
                      color: blackColor,
                      border: Border.all(
                        color: greenColor,
                        width: unitWidthValue * 2,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: AutoSizeText(
                      "\$${_quiz.amount}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: greenColor,
                        fontSize: unitHeightValue * 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: unitWidthValue * double.infinity,
                    padding: EdgeInsets.all(unitHeightValue * 2),
                    decoration: BoxDecoration(
                      color: blackColor,
                      border: Border.all(
                        color: greenColor,
                        width: unitWidthValue * 2,
                      ),
                      borderRadius: BorderRadius.circular(unitHeightValue * 6.0),
                    ),
                    child: AutoSizeText(
                      _quiz.title!.toUpperCase(),
                      textAlign: TextAlign.center,
                      minFontSize: 8,
                      maxLines: 1,
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: unitHeightValue * 24,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JackpotTriviaDetailsScreen(
                    quiz: _quiz,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void getQuiz({categoryID}) {
    setState(() {
      _isLoading = true;
    });
    jackpotCategoriesController.getQuiz(categoryID: categoryID).then(
      (value) {
        setState(
          () {
            quiz = value;
            buildSearchList();
            getCategories();
          },
        );
      },
    );
  }

  void getCategories() {
    jackpotCategoriesController.getCategories().then(
      (value) {
        setState(
          () {
            _isLoading = false;
            categories = value;
          },
        );
      },
    );
  }

  void buildSearchList() {
    searchQuiz.clear();
    if (searchWord == null || searchWord == "") {
      searchQuiz.addAll(quiz!);
    } else {
      for (int i = 0; i < quiz!.length; i++) {
        Quiz _class = quiz!.elementAt(i);
        String s = _class.title!.toLowerCase();
        if (s.contains(searchWord!.toLowerCase())) {
          searchQuiz.add(_class);
        }
      }
    }
  }
}
