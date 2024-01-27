import "package:dio/dio.dart";
import "package:html/parser.dart";
import "dart:convert";

class Cnusd {
  final _dio = Dio();

  Future<List<Map<String, dynamic>>> fetchNews() async {
    const targetUrl =
        "https://www.cnusd.k12.ca.us/c_n_u_s_d_c_o_n_n_e_c_t_i_o_n";
    var response = await _dio.get(targetUrl);
    var parsed = parse(response.data);
    var news = parsed.querySelectorAll("#news-summary > .row");

    List<Map<String, dynamic>> newsMap = [];

    for (final entry in news) {
      // formats the url so domain is included with the path
      var link = entry
          .querySelector(".content .read-more")
          ?.attributes["href"]
          ?.split("/")
          .last;

      var formattedLink = "$targetUrl/$link";

      Map<String, dynamic> entryMap = {
        "image": entry.querySelector(".image > img")?.attributes["src"],
        "title": entry.querySelector(".content .title")?.text.trim(),
        "date": entry.querySelector(".content .date")?.text.trim(),
        "summary": entry.querySelector(".content .summary")?.text.trim(),
        "link": formattedLink,
      };

      newsMap.add(entryMap);
    }

    return newsMap;
  }

  Future<List<Map<String, dynamic>>> fetchSchoolInformation() async {
    const targetUrl = "https://www.cnusd.k12.ca.us/DNE";

    var response = await _dio.get(
      targetUrl,
      options: Options(
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    var parsed = parse(response.data);

    List<Map<String, dynamic>> allSchoolInformation = [];
    List<String> schoolCategoryLabels = [];

    var schoolCategoryElements =
        parsed.querySelectorAll("#dropdown-tab > .tab-button");

    for (final category in schoolCategoryElements) {
      var categoryLabel = category.querySelector("a")?.text.trim();
      schoolCategoryLabels.add(categoryLabel!);
    }

    for (final (catIndex, catLabel) in schoolCategoryLabels.indexed) {
      var categoryHeader = parsed.querySelectorAll("li.schoolGroup")[catIndex];

      List<Map<String, dynamic>> schoolList = [];

      var nextElement = categoryHeader.nextElementSibling;
      while (nextElement != null) {
        if (nextElement.localName == "li" &&
            nextElement.className != "schoolGroup") {
          var schoolElement = nextElement.firstChild;
          Map<String, dynamic> schoolInformation = {
            "name": schoolElement?.text?.trim(),
            "link": schoolElement?.attributes["href"],
          };
          schoolList.add(schoolInformation);
        } else {
          break;
        }
        nextElement = nextElement.nextElementSibling;
      }

      Map<String, dynamic> categorySchoolInformation = {
        "category": catLabel,
        "schools": schoolList,
      };

      allSchoolInformation.add(categorySchoolInformation);
    }

    return allSchoolInformation;
  }

  Future<List<dynamic>> fetchStaffDirectory(
    String schoolUrl,
    String searchTerm,
    int searchStartIndex,
    int searchEndIndex, {
    int? imageSize,
    bool generateAvatarIfEmpty = false,
  }) async {
    schoolUrl = schoolUrl.substring(0, schoolUrl.length - 1);
    final staffDirUrl = "$schoolUrl/staff_directory";
    final staffDirBackendUrl =
        "$schoolUrl/Common/controls/StaffDirectory/ws/StaffDirectoryWS.asmx";

    var staffDirPageRes = await _dio.get(staffDirUrl);
    var parsed = parse(staffDirPageRes.data);

    var portletInstanceId = parsed
        .querySelector(".staffDirectoryComponent")
        ?.attributes["data-portlet-instance-id"];

    var staffDirSettingRes = await _dio.post(
      "$staffDirBackendUrl/Settings",
      data: {"portletInstanceId": portletInstanceId},
    );

    var staffDirGroups = staffDirSettingRes.data["d"]["groups"];

    var staffDirGroupIDs = [];
    for (final group in staffDirGroups) {
      staffDirGroupIDs.add(group["groupID"]);
    }

    var staffDirSearchTerm = searchTerm;

    var staffDirSearchRes = await _dio.post(
      "$staffDirBackendUrl/Search",
      data: {
        "firstRecord": searchStartIndex,
        "lastRecord": searchEndIndex,
        "portletInstanceId": portletInstanceId,
        "groupIds": staffDirGroupIDs,
        "searchTerm": staffDirSearchTerm,
        "sortOrder": "LastName,FirstName ASC",
        "searchByJobTitle": true
      },
    );

    var staffDirSearchResult = staffDirSearchRes.data["d"]["results"];

    for (final searchResult in staffDirSearchResult) {
      searchResult["fullName"] =
          searchResult["firstName"] + " " + searchResult["lastName"];

      if (searchResult["imageURL"].isNotEmpty) {
        searchResult["imageURL"] = schoolUrl + searchResult["imageURL"];

        if (imageSize != null) {
          searchResult["imageURL"] = searchResult["imageURL"].split("&")[0] +
              "&width=$imageSize&height=$imageSize";
        }
      }

      if (generateAvatarIfEmpty && searchResult["imageURL"].isEmpty) {
        String fullName = searchResult["fullName"].split(" ").join("+");
        searchResult["imageURL"] =
            "https://ui-avatars.com/api/?name=$fullName&background=random";
      }

      if (searchResult["mailUrl"].isNotEmpty) {
        searchResult["mailUrl"] = schoolUrl + searchResult["mailUrl"];
      }
    }

    return staffDirSearchResult;
  }

  Future<List<Map<String, dynamic>>> fetchSocialMedia([
    String schoolName = "",
  ]) async {
    const targetUrl = "https://www.cnusd.k12.ca.us/socialmedia";

    var response = await _dio.get(targetUrl);

    var parsed = parse(response.data);

    var socialMediaLoadScript =
        parsed.querySelector(".main-content script")?.innerHtml.split("\n");

    List<dynamic> rawSocialMediaList = [];

    for (final line in socialMediaLoadScript!) {
      String trimmed = line.trim();
      if (trimmed.startsWith("tabs: ")) {
        rawSocialMediaList =
            jsonDecode(trimmed.split("tabs: ")[1].split(",// required,")[0]);
      }
    }

    List<Map<String, dynamic>> schoolSocialMediaList = [];

    for (final school in rawSocialMediaList) {
      Map<String, dynamic> schoolSocialMediaInfo = {};

      List<Map<String, dynamic>> socialMediaList = [];

      var socialMediaElements = parse(school["content"]).querySelectorAll("a");

      for (final element in socialMediaElements) {
        Map<String, dynamic> socialMediaItem = {};

        var socialMediaAttributes = element.querySelector("img")?.attributes;

        var socialMediaName =
            socialMediaAttributes?["title"]?.split(" Logo")[0];
        var socialMediaLogo = socialMediaAttributes?["src"];

        socialMediaItem["platform"] = socialMediaName;
        socialMediaItem["logo"] = socialMediaLogo;
        socialMediaItem["link"] = element.attributes["href"];

        socialMediaList.add(socialMediaItem);
      }

      schoolSocialMediaInfo["name"] = school["title"];
      schoolSocialMediaInfo["socialMedia"] = socialMediaList;

      schoolSocialMediaList.add(schoolSocialMediaInfo);
    }

    if (schoolName.isNotEmpty) {
      for (final (index, school) in schoolSocialMediaList.indexed) {
        if (schoolName.toLowerCase().contains(school["name"].toLowerCase())) {
          return [schoolSocialMediaList[index]];
        }
      }
    }

    return schoolSocialMediaList;
  }
}
