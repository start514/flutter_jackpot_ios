import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterjackpot/utils/common_utils.dart';
import 'package:appodeal_flutter/appodeal_flutter.dart';

import 'common/shared_preferences.dart';

class AdMobClass {

  static void showVideoAdd(
      {@required void afterVideoEnd(), @required bool isSpin}) async {
    try {
      Preferences.getString(Preferences.pfKConsumableIdNoads).then(
        (value) {
          if (value == null || isSpin) {
    		Appodeal.setInterstitialCallback((event) {
			print('Interstitial ad triggered the event $event');
              		if (event == "onInterstitialClosed") {
                		afterVideoEnd();
              		} else if(event == "onInterstitialLoaded") {
				print("=====Before show");
				Appodeal.show(AdType.INTERSTITIAL);
			}
		});
		Appodeal.cache(AdType.INTERSTITIAL);
           
          } else {
            afterVideoEnd();
          }
        },
      );
    } catch (er) {
      print(er);
    }
  }

  static void showRewardAdd(
      {@required void afterVideoEnd(), @required bool isSpin}) async {
    try {
      Preferences.getString(Preferences.pfKConsumableIdNoads).then(
        (value) {
          if (value == null || isSpin) {
    		Appodeal.setRewardCallback((event) {
			print('Reward ad triggered the event $event');
              		if (event == "onRewardedVideoClosed" || event == "onRewardedVideoFinished") {
                		afterVideoEnd();
              		} else if(event == "onRewardedVideoLoaded") {
				print("=====Before show");
				Appodeal.show(AdType.REWARD);
			}
		});
		Appodeal.cache(AdType.REWARD);
           
          } else {
            afterVideoEnd();
          }
        },
      );
    } catch (er) {
      print(er);
    }
  }

  static MobileAdTargetingInfo _getMobileAdTargetingInfo() {
    return MobileAdTargetingInfo(
      keywords: <String>['flutterio', 'beautiful apps'],
      contentUrl: 'https://flutter.io',
      childDirected: false,
      testDevices: <String>[
        test_device_id1,
        test_device_id2,
        test_device_id3,
        test_device_id4,
        test_device_id5,
        test_device_id6,
        test_device_id7,
      ],
    );
  }
}
