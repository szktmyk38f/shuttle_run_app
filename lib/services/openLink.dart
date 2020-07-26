import 'package:url_launcher/url_launcher.dart';

class OpenLink {
  void launchURL() async {
    const url = "https://flutter.dev";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not Launch $url';
    }
  }
}