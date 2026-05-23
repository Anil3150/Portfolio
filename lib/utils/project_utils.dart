class ProjectUtils {
  final String image;
  final String title;
  final String subtitle;
  final String? androidLink;
  final String? iosLink;
  final String? webLink;

  ProjectUtils({
    required this.image,
    required this.title,
    required this.subtitle,
    this.androidLink,
    this.iosLink,
    this.webLink,
  });
}

List<ProjectUtils> projectUtilsList = [
  ProjectUtils(
    image: 'assets/projects/proj.png',
    title: 'Biztiny',
    subtitle: 'Buy, Sell, and Grow Your Business',
    androidLink: 'https://play.google.com/store/apps/details?id=com.biztiny',
  ),
  ProjectUtils(
    image: 'assets/projects/proj.png',
    title: 'Secure Your Land',
    subtitle: 'One App for All Your Property Needs',
    androidLink: 'https://drive.google.com/file/d/1AfcEDMpEYulFGO5KWCiCn4ShWDzJfKrW/view?usp=sharing',
  ),
  ProjectUtils(
    image: 'assets/projects/proj.png',
    title: 'Agri Insights',
    subtitle: 'Empowering Farmers, Connecting Markets',
    androidLink: 'https://drive.google.com/file/d/1fJnBASPCH9PAM-cNpdeg2DGw_ur1oGdy/view?usp=sharing',
  ),
];