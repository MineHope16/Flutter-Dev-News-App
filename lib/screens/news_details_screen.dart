import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/news_model.dart';
import 'package:flutter_news_app/utils/constants/app_assets.dart';
import 'package:flutter_news_app/utils/constants/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailsScreen extends StatelessWidget {
  final NewsModel article;

  static String id = "/newsDetails";

  //   final String loremIpsum600 = '''
  // Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod neque eu magna suscipit, ac convallis justo pulvinar. Curabitur ut ligula a orci tincidunt sodales. Aliquam erat volutpat. Etiam in viverra justo. Nullam at tincidunt mi. In non felis non quam mattis finibus. Nam et tincidunt ligula. Mauris porttitor cursus ante, sed tincidunt orci malesuada at. Nullam id elit efficitur, eleifend sem et, ullamcorper justo. Vivamus sed nibh eu turpis vehicula porta. Integer at nisi leo. Aenean convallis rutrum velit, eget imperdiet orci congue a. Quisque fermentum sem id justo fermentum, non tempor mi sollicitudin. Vestibulum blandit, leo ac egestas lacinia, eros nisl iaculis nisi, in convallis nulla eros nec ex. Pellentesque rhoncus urna at ipsum varius, at ultrices orci dictum. Aliquam et risus et sem blandit imperdiet. Donec a viverra erat. Nullam viverra sed velit ac fermentum. Sed imperdiet euismod dolor in fermentum. Morbi efficitur tincidunt arcu, non efficitur nibh dictum in. Morbi consequat metus ac lacus imperdiet, ac facilisis est rhoncus. Vivamus id facilisis leo. Aenean nec felis et ante pharetra varius. Curabitur id nulla purus. Morbi laoreet orci id gravida iaculis. Pellentesque ac est ac velit tincidunt lacinia. Integer in lobortis erat. Fusce et tincidunt purus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Integer sollicitudin varius ante, nec fermentum turpis lobortis a. Curabitur volutpat sagittis nibh, a fringilla justo feugiat et. Suspendisse potenti. Integer scelerisque sem eget massa vestibulum, at tincidunt ligula efficitur. Pellentesque dignissim neque ac dolor egestas, et finibus libero rutrum. In vel facilisis nulla. Suspendisse potenti. Integer tristique ut purus nec bibendum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Aenean tempor risus a erat bibendum, sit amet feugiat purus congue. Cras accumsan justo a ligula tincidunt, in varius sapien vehicula. Donec fermentum felis ut mauris tincidunt, a feugiat lorem pretium. Donec vel sapien felis. Pellentesque lacinia sapien non finibus bibendum. Integer ac nibh quis libero suscipit sagittis. In id sapien non sem placerat pulvinar. Integer laoreet justo id ipsum viverra convallis. Suspendisse potenti. Nullam rutrum magna metus, ac elementum sem laoreet a. Nullam et eros metus. Curabitur eget felis mi. Suspendisse eget purus ut ligula fermentum placerat. Maecenas ac tempor lorem. Mauris vestibulum ipsum at justo vulputate, in lobortis orci rutrum. Sed nec neque vitae ipsum feugiat dapibus. Pellentesque vitae arcu rutrum, accumsan odio in, vulputate tortor. Etiam tristique eget leo vitae malesuada. Quisque nec eros in lacus elementum congue. Sed finibus placerat justo, a tincidunt orci. Donec euismod, eros at dictum tincidunt, orci metus facilisis velit, a commodo risus enim at dolor. Suspendisse eu purus a enim pretium congue. Nam sagittis dignissim justo ac ultrices. Phasellus vel justo vel lectus tincidunt fermentum. Mauris porta velit ut arcu sollicitudin blandit. Cras gravida nisl nec volutpat accumsan. Curabitur gravida sagittis arcu, vitae pretium justo posuere non. Proin viverra ante vitae tortor fermentum bibendum. Sed et vehicula est, sit amet imperdiet velit. Nam in ex malesuada, imperdiet tortor at, dapibus justo. Maecenas lobortis quam nec arcu placerat, eget aliquam lorem tincidunt. Phasellus condimentum nulla nec quam accumsan mattis. Morbi id orci sagittis, porta purus ut, scelerisque arcu. Duis nec diam nec magna viverra lobortis. Nam maximus dapibus augue, nec porttitor augue. Mauris nec odio risus. Quisque pretium rhoncus sem, ut sagittis enim malesuada id. Vestibulum et convallis libero, vitae iaculis elit. Donec accumsan bibendum risus, ac malesuada ipsum. Integer vel luctus libero. Nunc porttitor iaculis augue, id tincidunt lacus. Mauris nec vestibulum metus. Nam blandit massa non faucibus dapibus.
  // ''';

  const NewsDetailsScreen({super.key, required this.article});

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy – hh:mm a').format(date.toLocal());
    } catch (e) {
      return dateStr;
    }
  }

  String _formatContent(String content) {
    return content.split("[+").first;
  }

  Future<void> _launchInBrowser(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: NewsAppColors.scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Row(
            children: [
              Image.asset(AppAssets.logo, height: 40),
              const SizedBox(width: 10),
              Text(
                "HeadLyne",
                style: TextStyle(
                  color: NewsAppColors.splashScreenLogoColor,
                  fontFamily: "NewsV",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              SharePlus.instance.share(
                ShareParams(
                  text: '${article.title}\n\nRead more: ${article.newsURL}',
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: article.imageURL.isNotEmpty
                    ? Hero(
                        tag: article.imageURL,
                        child: Image.network(
                          article.imageURL,
                          width: double.maxFinite,
                          height: 220,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        AppAssets.imageNotFound,
                        height: 220,
                        width: double.maxFinite,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 16),

              // Card-like content container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black87,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Source & Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          article.sourceName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey,
                          ),
                        ),
                        Text(
                          _formatDate(article.publishedAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Title
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Author
                    if (article.author.isNotEmpty)
                      Text(
                        "By ${article.author}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.black54,
                        ),
                      ),

                    const Divider(height: 30),

                    // Description
                    if (article.description.isNotEmpty)
                      Text(
                        article.description,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),

                    const SizedBox(height: 16),

                    // Content
                    if (article.content.isNotEmpty)
                      Text(
                        _formatContent(article.content),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),

                    const SizedBox(height: 28),

                    // Read More Button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () => _launchInBrowser(article.newsURL),
                        icon: const Icon(Icons.open_in_new),
                        label: const Text("Read Full Article"),
                        style: ElevatedButton.styleFrom(
                          elevation: 3,
                          backgroundColor: NewsAppColors.splashScreenLogoColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
