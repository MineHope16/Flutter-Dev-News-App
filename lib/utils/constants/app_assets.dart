/// Asset paths used throughout the app.
abstract class AppAssets {
  // Base paths
  static const String _anim = "assets/animations";
  static const String _images = "assets/images";

  // Animations
  static const String splashAnim = "$_anim/splash_anim.json";

  // Images
  static const String logo = "$_images/logo.png";
  static const String imageNotFound = "$_images/news_image_not_found.png";

  // Prevent instantiation
  const AppAssets._();
}
