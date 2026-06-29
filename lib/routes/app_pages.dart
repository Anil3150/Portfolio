import 'package:get/get.dart';
import 'package:portfolio/modules/portfolio/bindings/portfolio_binding.dart';
import 'package:portfolio/modules/portfolio/views/portfolio_view.dart';
import 'package:portfolio/routes/app_routes.dart';

class AppPages {
  const AppPages._();

  static final pages = [
    GetPage(
      name: AppRoutes.portfolio,
      page: () => const PortfolioView(),
      binding: PortfolioBinding(),
    ),
  ];
}
