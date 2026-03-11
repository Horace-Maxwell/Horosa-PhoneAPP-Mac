import 'package:flutter/material.dart';
import 'package:horosa/pages/pages.dart';

Map<String, Widget Function(BuildContext)> routes = {
  SplashPage.route: (context) => const SplashPage(),
  LoginPage.route: (context) => const LoginPage(),
  HomePage.route: (context) => const HomePage(),
  BaZiFormPage.route: (context) => const BaZiFormPage(),
  BaZiResultPage.route: (context) => const BaZiResultPage(),
  LiuYaoFormPage.route: (context) => const LiuYaoFormPage(),
  LiuYaoResultPage.route: (context) => const LiuYaoResultPage(),
  CoinLinesPage.route: (context) => const CoinLinesPage(),
  LiuRenFormPage.route: (context) => const LiuRenFormPage(),
  LiuRenResultPage.route: (context) => const LiuRenResultPage(),
  QiMenFormPage.route: (context) => const QiMenFormPage(),
  QiMenResultPage.route: (context) => const QiMenResultPage(),
  SettingsPage.route: (context) => const SettingsPage(),
  UserInfoPage.route: (context) => const UserInfoPage(),
  EditUserInfoPage.route: (context) => const EditUserInfoPage(),
  BirthDataRepo.route: (context) => const BirthDataRepo(),
  AboutUsPage.route: (context) => const AboutUsPage(),
  FeedbackPage.route: (context) => const FeedbackPage(),
  PrivacyPolicyPage.route: (context) => const PrivacyPolicyPage(),
  TermsOfServicePage.route: (context) => const TermsOfServicePage(),
};