import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";
import "package:cached_network_image/cached_network_image.dart";

import 'custom_progress_indicator.dart';

import "../utilities/fetch_cnusd.dart";

class NewsContainer extends StatefulWidget {
  const NewsContainer({super.key});

  @override
  State<NewsContainer> createState() => NewsContainerState();
}

class NewsContainerState extends State<NewsContainer>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _cnusd = Cnusd();

  Future<List<SingleNewsContainer>> _loadNews() async {
    List<SingleNewsContainer> result = [];
    List<Map<String, dynamic>> newsList = await _cnusd.fetchNews();
    for (final newsInfo in newsList) {
      result.add(SingleNewsContainer(newsInfo: newsInfo));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder(
      future: _loadNews(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        List<SingleNewsContainer> children = [];
        if (snapshot.hasData) {
          children = snapshot.data;
        } else if (snapshot.hasError) {
          return Text("An Error Occured: ${snapshot.error}");
        } else {
          return const CustomProgressIndicator(subwidget: Text("Loading News"));
        }

        return ListView.builder(
          itemCount: children.length,
          itemBuilder: (context, i) {
            return children.elementAt(i);
          },
        );
      },
    );
  }
}

class SingleNewsContainer extends StatelessWidget {
  final Map<String, dynamic> newsInfo;
  const SingleNewsContainer({super.key, required this.newsInfo});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: newsInfo["image"] ??
                        "https://singlecolorimage.com/get/808080/400x200",
                    placeholder: (context, url) =>
                        const CustomProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(newsInfo["date"]),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                newsInfo["title"],
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                newsInfo["summary"],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () => _launchUrl(newsInfo["link"]),
                  child: const Text("Read More")),
            )
          ],
        ),
      ),
    );
  }
}
