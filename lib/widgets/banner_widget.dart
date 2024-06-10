import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() {
    return _BannerAdWidgetState();
  }
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? banner;

  void setAdMob() async {
    await dotenv.load(fileName: ".env");

    final adUnitId = Platform.isIOS
        ? dotenv.env['IOSUNITID'].toString()
        : dotenv.env['ANDROIDUNITID'].toString();

    banner = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,
      listener: BannerAdListener(onAdFailedToLoad: (ad, error) {
        ad.dispose();
      }),
      request: AdRequest(),
    );

    banner!.load();
  }

  @override
  void initState() {
    super.initState();
    setAdMob();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    banner!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (banner != null) {
      return SizedBox(
        height: 75,
        child: AdWidget(ad: banner!),
      );
    }
    return Center(
      child: Text(""),
    );
  }
}
