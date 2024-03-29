import 'package:flutter/material.dart';
import 'package:insomnia_pub/net/http_nw.dart';
import 'package:insomnia_pub/util/Utils.dart';
import 'package:insomnia_pub/util/constants.dart';
import 'package:insomnia_pub/util/feedback_bar.dart';
import 'package:insomnia_pub/util/progress_indicator.dart';

class FeedBackWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FeedBackWidgetState();
  }
}

class FeedBackWidgetState extends State<FeedBackWidget> {
  int foodRatting = 0;
  int serviceRatting = 0;
  int settingRatting = 0;
  int overAllRatting = 0;
  TextEditingController reviewText;

  bool loadingStatus = false;

  @override
  void initState() {
    super.initState();
    reviewText = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressWidget(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            FeedBackBarWidget(
              label: "Food",
              onRattingChange: foodRattingChange,
              selectedRatting: foodRatting,
              ),
            FeedBackBarWidget(
              label: "Service",
              onRattingChange: serviceRattingChange,
              selectedRatting: serviceRatting,
              ),
            FeedBackBarWidget(
              label: "Setting",
              onRattingChange: settingRattingChange,
              selectedRatting: settingRatting,
              ),
            FeedBackBarWidget(
              label: "Over all",
              onRattingChange: overAllRattingChange,
              selectedRatting: overAllRatting,
              ),
            getReviewTitle("Your Review"),
            Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
//              margin: EdgeInsets.all(15),
              height: 180,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                      color: Constants.COLORMAIN.withAlpha(100), width: 2)),
              child: new TextField(
                controller: reviewText,
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.black),
                decoration: new InputDecoration(
                  hintText: "Type here",
                  hintStyle: TextStyle(color: Colors.grey[700]),
                  border: InputBorder.none,
                  ),
                ),
              ),
            getSubmitButton(),
          ],
          ),
        ),
      isLoading: loadingStatus,
      );
  }

  Widget getReviewTitle(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 15, left: 15, bottom: 8),
      child: Text(
        value,
        textDirection: TextDirection.ltr,
        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Constants.COLORMAIN),
        ),
      );
  }

  void foodRattingChange(int value) {
    this.foodRatting = value;
  }

  void serviceRattingChange(int value) {
    this.serviceRatting = value;
  }

  void settingRattingChange(int value) {
    this.settingRatting = value;
  }

  void overAllRattingChange(int value) {
    this.overAllRatting = value;
  }

  Widget getSubmitButton() {
    return InkWell(
      onTap: () => onSubmitRatting(),
      child: Container(
        margin: EdgeInsets.only(top: 30.0),
        padding: EdgeInsets.only(top: 15, bottom: 15),
        width: 200,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          gradient: LinearGradient(
              colors: [Color(0xffe2cda0), Constants.COLORMAIN],
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              stops: [0.0, 1.0],
              tileMode: TileMode.repeated),
          ),
        child: Text(
          "SUBMIT",
          style: TextStyle(color: Colors.black, fontSize: 24),
          ),
        ),
      );
  }

  void onSubmitRatting() {
    if (foodRatting == 0) {
      Utils.showToast("Please rate our Food", Colors.redAccent, Colors.white);
      return;
    } else if (serviceRatting == 0) {
      Utils.showToast(
          "Please rate our Service's", Colors.redAccent, Colors.white);
      return;
    } else if (settingRatting == 0) {
      Utils.showToast("Please rate our Setting's and Arrangement",
                          Colors.redAccent, Colors.white);
      return;
    } else if (overAllRatting == 0) {
      Utils.showToast(
          "Please rate our Over all", Colors.redAccent, Colors.white);
      return;
    }
    AppHttpRequest.submitFeedBack(121, foodRatting, serviceRatting,
                                      settingRatting, overAllRatting, reviewText.text)
        .then((response) {
      setState(() {
//        if(response is Map)
        loadingStatus = false;
        reviewText.text = "";
        foodRatting = 0;
        serviceRatting = 0;
        settingRatting = 0;
        overAllRatting = 0;
      });
      Utils.showToast("Thank's for valuble feedback");
    });

    setState(() {
      loadingStatus = true;
    });
  }
}
