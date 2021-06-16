import 'package:flutter/material.dart';
import 'package:saloon_app/AppStrings.dart';
import 'package:saloon_app/widgets/Buttons.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  ValueNotifier<int> pageNotifier = ValueNotifier<int>(0);
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: PageView.builder(
                controller: pageController,
                itemBuilder: (ctx, index) {
                  return Image.asset(AppStrings.onboarding_images[index], fit: BoxFit.cover);
                },
                itemCount: 3,
                onPageChanged: (index) {
                  pageNotifier.value = index;
                },
              ),
            ),
            flex: 6,
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder(
                    valueListenable: pageNotifier,
                    builder: (_, int index, __) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          AppStrings.onboarding_titles[index],
                          style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: pageNotifier,
                    builder: (_, int index, __) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          AppStrings.onboarding_descriptions[index],
                          style: Theme.of(context).textTheme.caption.copyWith(fontSize: 16),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    child: RoundedCornerButtonSolid(
                      () {
                        print(pageNotifier.value);
                        if (pageNotifier.value < 2) {
                          pageController.nextPage(duration: Duration(milliseconds: 650), curve: Curves.ease);
                          return;
                        }
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      'Next',
                    ),
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  ),
                  Container(
                    child: RoundedCornerButtonOutlined(
                      () {
                        if (pageNotifier.value != 0) {
                          pageController.previousPage(duration: Duration(milliseconds: 650), curve: Curves.ease);
                          return;
                        }
                      },
                      'Skip',
                    ),
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
