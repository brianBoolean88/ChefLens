import "dart:io";
import "dart:typed_data";
import "package:cookie_jar/cookie_jar.dart";
import "package:dio/dio.dart";
import "package:dio_cookie_manager/dio_cookie_manager.dart";
import "package:html/parser.dart";
import "package:html/dom.dart";

class LoginException implements Exception {
  final String message;

  LoginException(this.message);

  @override
  String toString() => message;
}

class StudentConnect {
  static const String studentConnectURL =
      "https://studentconnect.cnusd.k12.ca.us";
  static const String mobileUserAgent =
      "Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/116.0.5845.146 Mobile/15E148 Safari/604.1";
  static const String desktopUserAgent =
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36";
  static const Duration studentSelectDelay = Duration(seconds: 2);

  late Dio _dio;
  late CookieJar _cookieJar;

  late String userID;
  late String userPassword;

  bool isLoggedIn = false;

  StudentConnect() {
    _dio = Dio(
      BaseOptions(
        baseUrl: studentConnectURL,
        headers: {
          HttpHeaders.userAgentHeader: desktopUserAgent,
        },
      ),
    );

    _cookieJar = CookieJar();
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  /// Gets the target sub-elements and trims the values
  List<String> getSubElementText(Element parentElement, String childTag) {
    List<String> result = [];
    final targetElements = parentElement.getElementsByTagName(childTag);

    for (final element in targetElements) {
      String studentDoc =
          element.querySelector("#opendoc")?.attributes["href"] ?? "";
      String checkMark = element.querySelector("img")?.attributes["alt"] ?? "";

      if (checkMark == "checked") {
        result.add("true");
      } else if (studentDoc.isNotEmpty) {
        final studentDocumentGuid =
            RegExp("'([^']+)'").firstMatch(studentDoc)?.group(1) ?? "";
        result.add(studentDocumentGuid);
      } else {
        final trimmed = element.text.trim().replaceAll(RegExp(r"[^\S ]"), "");
        result.add(trimmed);
      }
    }

    return result;
  }

  /// Get all cookie names and value (name=value; name=value; )
  Future<String> getCookies() async {
    String result = "";

    var cookies = await _cookieJar
        .loadForRequest(Uri.parse("https://studentconnect.cnusd.k12.ca.us/"));

    for (final cookie in cookies) {
      result += "${cookie.name}=${cookie.value}; ";
    }

    return result;
  }

  /// Logs into Student Connect and gets the available tracks
  Future<void> login(String userID, String userPassword) async {
    this.userID = userID;
    this.userPassword = userPassword;

    final loginData = {
      "districtid": "connect",
      "Pin": userID,
      "Password": userPassword,
      "GuidFromQ": "",
    };

    try {
      final loginResponse =
          await _dio.post("/Home/Login", data: FormData.fromMap(loginData));

      if (loginResponse.data["valid"] == "0") {
        throw LoginException("Login failed");
      }

      final studentList = await _dio.get(
        "/Home/LoadStuMobileList",
        options: Options(
          headers: {
            HttpHeaders.userAgentHeader: mobileUserAgent,
          },
        ),
      );

      final studentTracks =
          parse(studentList.data).getElementsByClassName("clsMyStudents");

      String studentTrackID = "";

      for (final studentTrack in studentTracks) {
        studentTrackID = RegExp(r"\d+")
            .stringMatch(studentTrack.attributes["href"] ?? "")
            .toString();
      }

      await _dio.get("/StudentBanner/SetStudentBanner/$studentTrackID");
      // print("Student Track Selected ($studentTrackID)");

      await Future.delayed(studentSelectDelay);
      isLoggedIn = true;
    } catch (e) {
      throw ("Login failed: $e");
    }
  }

  /// Fetches and downloads http response from endpoints
  Future<void> fetchEndpointData(String endpoint) async {
    try {
      final response = await _dio.get("/Home/LoadProfileData/$endpoint");
      final file = File("results/$endpoint.html");
      await file.create(recursive: true);
      await file.writeAsString(response.data);
    } catch (e) {
      throw ("An error occurred while fetching $endpoint: $e");
    }
  }

  /// Fetches the attendance data, [targetData] is used to determine the target table to scrape from: (reason, class, detail)
  Future<List<Map<String, String>>> fetchAttendance(String targetData) async {
    try {
      final response = await _dio.get("/Home/LoadProfileData/Attendance");
      final document = parse(response.data);

      String target;
      switch (targetData) {
        case "reason":
          target = "#SP-AttendanceByReason";
          break;

        case "class":
          target = "#SP-AttendanceByClass";
          break;

        case "detail":
          target = "#SP-AttendanceDetail";
          break;

        default:
          throw ArgumentError("Invalid targetData: $targetData");
      }

      final rows = document.querySelectorAll("$target tr");

      List<Map<String, String>> attendance = [];

      final tableHeaders = getSubElementText(rows[0], "th");

      for (final row in rows.sublist(1)) {
        final Map<String, String> attendanceData = {};
        final attendanceDetail = getSubElementText(row, "td");
        for (final (index, header) in tableHeaders.indexed) {
          attendanceData[header] = attendanceDetail[index];
        }

        attendance.add(attendanceData);
      }

      return attendance;
    } catch (e) {
      throw ("An error occurred while fetching Attendance: $e");
    }
  }

  /// Fetches the Pulse data
  Future<List<Map<String, String>>> fetchPulse() async {
    try {
      final response = await _dio.get("/Home/LoadProfileData/Pulse");
      final document = parse(response.data);
      final rows = document.getElementsByTagName("tr");

      List<Map<String, String>> pulse = [];

      final tableHeaders = getSubElementText(rows[0], "th");

      for (final row in rows.sublist(1)) {
        final Map<String, String> pulseData = {};
        final pulseDetail = getSubElementText(row, "td");
        for (final (index, header) in tableHeaders.indexed) {
          pulseData[header] = pulseDetail[index];
        }

        pulse.add(pulseData);
      }

      return pulse;
    } catch (e) {
      throw ("An error occurred while fetching Pulse: $e");
    }
  }

  /// Fetches the Schedule Data
  Future<List<Map<String, String>>> fetchSchedule() async {
    try {
      final response = await _dio.get("/Home/LoadProfileData/Schedule");
      final document = parse(response.data);
      final rows = document.getElementsByTagName("tr");

      List<Map<String, String>> schedule = [];

      final tableHeaders = getSubElementText(rows[0], "th");

      for (final row in rows.sublist(1)) {
        final Map<String, String> scheduleData = {};
        final scheduleDetail = getSubElementText(row, "td").sublist(1);
        for (final (index, header) in tableHeaders.indexed) {
          scheduleData[header] = scheduleDetail[index];
        }

        schedule.add(scheduleData);
      }

      return schedule;
    } catch (e) {
      throw ("An error occurred while fetching Schedule: $e");
    }
  }

  /// Fetches the Schedule Data
  Future<List<dynamic>> fetchAssignments() async {
    try {
      final response = await _dio.get("/Home/LoadProfileData/Assignments");
      final document = parse(response.data);
      final courses = document.getElementsByTagName("table");

      List<dynamic> assignments = [];

      for (final course in courses) {
        Map courseData = {};
        final rows = course.getElementsByTagName("tr");

        final courseHeading = course
            .getElementsByTagName("caption")[0]
            .text
            .trim()
            .split(RegExp(r"\s+"));

        final courseHeadingData = {
          "period": courseHeading.elementAt(1),
          "course_name":
              courseHeading.sublist(2, courseHeading.length - 1).join(" "),
          "course_id": courseHeading.last.replaceAll(RegExp(r"[()]"), ""),
        };

        courseData["course_heading"] = courseHeadingData;

        final courseOverview = rows[0]
            .getElementsByTagName("td")[0]
            .text
            .trim()
            .split(": ")[1]
            .split(RegExp(r"\s+"));

        final hasPercentage = courseOverview.length == 2;

        final teacherInfo =
            rows[0].getElementsByTagName("td")[1].getElementsByTagName("a")[0];

        final courseOverviewData = {
          "teacher_name": teacherInfo.text.trim(),
          "teacher_email": teacherInfo.attributes["href"]?.split(":").last,
          "letter_grade": courseOverview[0],
          "has_percentage": hasPercentage,
          "percentage": hasPercentage
              ? double.tryParse(
                  courseOverview[1].replaceAll(RegExp(r"[(%)]"), ""))
              : "",
        };
        courseData["course_overview"] = courseOverviewData;

        var courseAssignments = [];
        final tableHeaders = getSubElementText(rows[1], "th");

        for (final row in rows.sublist(2)) {
          Map assignmentData = {};
          final assignmentDetail = getSubElementText(row, "td");

          for (final (index, header) in tableHeaders.indexed) {
            assignmentData[header] = assignmentDetail[index];
          }

          courseAssignments.add(assignmentData);
        }

        courseData["assignments"] = courseAssignments;

        assignments.add(courseData);
      }

      return assignments;
    } catch (e) {
      throw ("An error occurred while fetching Assignments: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchStudentDocuments() async {
    try {
      final response = await _dio.get("/Home/LoadProfileData/SPDynamic_542");
      final document = parse(response.data);
      final rows =
          document.getElementsByTagName("#Student\\ DocumentsTable tr");

      List<Map<String, dynamic>> studentDocuments = [];

      final tableHeaders = getSubElementText(rows[0], "th");

      for (final row in rows.sublist(1)) {
        final Map<String, dynamic> scheduleData = {};
        final scheduleDetail = getSubElementText(row, "td");
        for (final (index, header) in tableHeaders.indexed) {
          scheduleData[header] = scheduleDetail[index];
        }

        scheduleData["DocumentLink"] =
            "$studentConnectURL/Document/LoadDocument/${scheduleDetail.last}";

        studentDocuments.add(scheduleData);
      }

      return studentDocuments;
    } catch (e) {
      throw ("An error occurred while downloading Student Report: $e");
    }
  }

  /// Download file with provided url and path
  Future<void> downloadFile(String url, String path) async {
    try {
      await _dio.download(url, path);
    } catch (e) {
      throw ("An error occurred when downloading from $url: $e");
    }
  }

  /// Downloads the student report, [filename] determines the downloaded file name
  Future<void> downloadStudentReport(String filename) async {
    try {
      final response = await _dio.get(
        "/Home/PrintStudentReport",
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      final file = File("results/$filename.pdf");
      await file.writeAsBytes(response.data, flush: true);
    } catch (e) {
      throw ("An error occurred while downloading Student Report: $e");
    }
  }

  /// Get raw student image bytes
  Future<Uint8List> fetchStudentPhoto() async {
    final response = await _dio.get(
      "$studentConnectURL/StudentBanner/ShowImage/$userID",
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );

    return response.data;
  }

  /// Fetch student info
  Future<Map<String, dynamic>> fetchStudentInfo() async {
    Map<String, String> studentInfo = {};
    final response = await _dio.get(
      "/Home/LoadStuMobileList",
      options: Options(
        headers: {
          HttpHeaders.userAgentHeader: mobileUserAgent,
        },
      ),
    );

    final document = parse(response.data);

    var rawInfo = document.querySelectorAll(".clsMyStudents")[1];

    List<String> schoolInfo = rawInfo
        .querySelectorAll("div")[2]
        .text
        .trim()
        .replaceAll(RegExp(r"[^\S ]"), "")
        .split(" " * 8);

    studentInfo["fullName"] = rawInfo.querySelector("div > b")?.text ?? "";

    studentInfo["gradeLevel"] = rawInfo
            .querySelector("div > div")
            ?.text
            .replaceAll(RegExp(r"\D"), "") ??
        "";

    studentInfo["trackName"] = schoolInfo[0];

    studentInfo["schoolYear"] = schoolInfo[1];

    return studentInfo;
  }

  /// Sends logout request to StudentConnect
  Future<void> logout() async {
    try {
      await _dio.get("/Home/Logout");
    } catch (e) {
      throw ("Logout failed: $e");
    }
  }
}
