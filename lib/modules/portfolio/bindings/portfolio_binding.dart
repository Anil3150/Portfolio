import 'package:get/get.dart';
import 'package:portfolio/data/repositories/portfolio_repository.dart';
import 'package:portfolio/modules/portfolio/controllers/portfolio_controller.dart';
import 'package:portfolio/services/resume_parser_service.dart';

class PortfolioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(PortfolioRepository.new);
    Get.lazyPut(ResumeParserService.new);
    Get.lazyPut(
      () => PortfolioController(
        Get.find<PortfolioRepository>(),
        Get.find<ResumeParserService>(),
      ),
    );
  }
}
