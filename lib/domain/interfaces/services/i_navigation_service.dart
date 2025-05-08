///
abstract class INavigationService {
  Future<dynamic> navigateTo(String routeName, {Object? arguments});
  Future<dynamic> replaceWith(String routeName, {Object? arguments});
  Future<dynamic> replaceWithoutAnimation(String routeName, {Object? arguments});
  void goBack();
}
