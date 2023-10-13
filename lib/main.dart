import 'package:flutter/material.dart';
import 'package:flutter_application_1/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  RequestConfiguration requestConfiguration = RequestConfiguration(
    testDeviceIds: ['ECB3A80DA4A1185CD3906A30F96AD7C3'],
  );

  MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BannerAd? _banner;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  int _rewardedScore = 0;
  @override
  void initState() {
    super.initState();

    _createBannerAd();
    _createInterstitialAd();
    _createRewardedAd();
  }

  void _createBannerAd() {
    _banner = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdHelper.bannerAdUnitId,
        listener: AdHelper.bannerListener,
        request: const AdRequest())
      ..load();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) => _interstitialAd = ad,
          onAdFailedToLoad: (LoadAdError error) => _interstitialAd = null),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  void _createRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => setState(() => _rewardedAd),
        onAdFailedToLoad: (error) => setState(() => _rewardedAd = null),
      ),
    );
  }

  void _showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createInterstitialAd();
        }
      );
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) => setState(() => _rewardedScore++)
      );
      _rewardedAd = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Layout")),
        body: Column(children: <Widget>[
          Image.asset('Assets/gambar.jpg'),
          titleSection,
          buttonSection,
          Container(
            padding: const EdgeInsets.all(32),
            child: Text(
                'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
                'but you aint have any money? you just need ur score above 5 to go there '
                'UR SCORE IS $_rewardedScore'),
          ),
          ElevatedButton(
              onPressed: _showInterstitialAd,
              child: const Text("InterstitialAd")),
          ElevatedButton(onPressed: _showRewardedAd, child: const Text('Get 1 free score'))
        ]),
        bottomNavigationBar: _banner == null
            ? Container()
            : Container(
                margin: const EdgeInsets.only(bottom: 12),
                height: 52,
                child: AdWidget(ad: _banner!),
              ),
      ),
    );
  }
}

Widget titleSection = Container(
  padding: const EdgeInsets.all(32),
  child: const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              "Oeschinen Lake Campground",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              "Kandersteg, Switzerland",
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.star,
              color: Colors.red,
            ),
            Text("41"),
          ],
        )
      ]),
);

Widget buttonSection = Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: <Widget>[
    btnSection(Icons.phone, 'Phone'),
    btnSection(Icons.navigation, 'Route'),
    btnSection(Icons.share, 'Share')
  ],
);

Container btnSection(IconData icon, String text) {
  return Container(
      child: InkWell(
    onTap: () {},
    child: Column(
      children: <Widget>[
        Icon(
          icon,
          color: Colors.blue,
        ),
        Text(text)
      ],
    ),
  ));
}

Widget textSection = Container(
  padding: const EdgeInsets.all(32),
  child: const Text(
      'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
      'but you aint have any money? you just ur score above 5 to go there '
      'UR SCORE IS'),
);

// class BannerExample extends StatefulWidget {
//   const BannerExample({super.key});

//   @override
//   BannerExampleState createState() => BannerExampleState();
// }

// class BannerExampleState extends State<BannerExample> {
//   BannerAd? _bannerAd;
//   bool _isLoaded = false;

//   final adUnitId = 'ca-app-pub-6791221543817725/6729545012';

//   @override
//   void initState() {
//     super.initState();
//     loadAd(); // Memuat iklan saat widget ini diinisialisasi.
//   }

//   void loadAd() {
//     _bannerAd = BannerAd(
//       adUnitId: adUnitId,
//       request: const AdRequest(),
//       size: AdSize.banner,
//       listener: BannerAdListener(
//         onAdLoaded: (ad) {
//           debugPrint('$ad loaded.');
//           setState(() {
//             _isLoaded = true;
//           });
//         },
//         onAdFailedToLoad: (ad, err) {
//           debugPrint('BannerAd failed to load: $err');
//           ad.dispose();
//         },
//       ),
//     )..load();
//   }

//   @override
//   void dispose() {
//     _bannerAd?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isLoaded
//         ? AdWidget(ad: _bannerAd!)
//         : const Text('Iklan belum dimuat');
//   }
// }