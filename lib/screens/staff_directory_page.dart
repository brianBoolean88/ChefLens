import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";
import "package:cached_network_image/cached_network_image.dart";

import '../widgets/custom_progress_indicator.dart';

import "../utilities/fetch_cnusd.dart";

class StaffDirectoryPage extends StatefulWidget {
  const StaffDirectoryPage({super.key});

  @override
  State<StaffDirectoryPage> createState() => _StaffDirectoryPageState();
}

class _StaffDirectoryPageState extends State<StaffDirectoryPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _cnusd = Cnusd();
  final searchController = TextEditingController();

  List<Widget> _staffList = [];

  Future<void> _fetchData(String websiteDomain, String searchTerm) async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const Center(
              child: CustomProgressIndicator(
            subwidget: Text("Fetching Information"),
          ));
        },
      );
      var searchResult = await _cnusd.fetchStaffDirectory(
          websiteDomain, searchTerm, 0, 10,
          imageSize: 512, generateAvatarIfEmpty: true);

      if (!context.mounted) return;
      Navigator.of(context).pop();

      setState(() {
        _staffList = [];

        for (final profile in searchResult) {
          _staffList.add(StaffProfileCard(profileData: profile));
        }
      });
    } catch (error) {
      debugPrint('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter a search term",
                    ),
                    controller: searchController,
                  ),
                ),
              ),
            ],
          ),
          ElevatedButton(
            child: const Text("Search"),
            onPressed: () => {
              _fetchData(
                "https://barton.cnusd.k12.ca.us/",
                searchController.text,
              )
            },
          ),
          Column(
            children: _staffList,
          )
        ],
      ),
    );
  }
}

class StaffProfileCard extends StatelessWidget {
  final Map<String, dynamic> profileData;

  const StaffProfileCard({super.key, required this.profileData});

  Future<void> _openUrl(String targetUrl) async {
    if (!await launchUrl(Uri.parse(targetUrl))) {
      throw Exception('Could not launch $targetUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage: CachedNetworkImageProvider(
                profileData["imageURL"],
              ),
            ),
            Text(profileData["fullName"]),
          ],
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    profileData["jobTitle"],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text("Contacts"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () => {_openUrl(profileData["mailUrl"])},
                          icon: const Icon(Icons.mail_lock_outlined),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
