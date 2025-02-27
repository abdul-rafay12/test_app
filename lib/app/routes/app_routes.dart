import 'package:get/get.dart';
import '../modules/home/views/home_view.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/home', page: () => HomeView()),
  ];
}
