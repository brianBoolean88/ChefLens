import "dart:io";

import "package:cnusd_app/widgets/custom_progress_indicator.dart";
import "package:flutter/material.dart";
import "package:open_filex/open_filex.dart";
import "package:path_provider/path_provider.dart";

import "../../widgets/expandable_card.dart";

import "../../utilities/studentconnect.dart";

class StudentInfoContainer extends StatefulWidget {
  final StudentConnect studentConnect;
  final ColorScheme appColorScheme;
  const StudentInfoContainer({
    super.key,
    required this.studentConnect,
    required this.appColorScheme,
  });

  @override
  State<StudentInfoContainer> createState() => StudentInfoContainerState();
}

class StudentInfoContainerState extends State<StudentInfoContainer>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<List<Widget>> _getStudentInfo(
    StudentConnect sc,
    ColorScheme appColorScheme,
  ) async {
    List<Widget> studentInfo = [];
    Map<String, dynamic> studentInfoDetail = await sc.fetchStudentInfo();

    final studentPhotoData = await sc.fetchStudentPhoto();

    studentInfo.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 70.0,
          backgroundImage: Image.memory(studentPhotoData).image,
        ),
      ),
    );

    studentInfo.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(studentInfoDetail["fullName"]),
                  Text("Grade: ${studentInfoDetail['gradeLevel']}"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(studentInfoDetail["trackName"]),
                  Text(studentInfoDetail["schoolYear"]),
                ],
              ),
            )
          ],
        ),
      ),
    );

    return studentInfo;
  }

  Future<ExpandableCard> _fetchStudentDocuments(
      StudentConnect sc, ColorScheme appColorScheme) async {
    List<Card> documentList = [];

    for (final item in await sc.fetchStudentDocuments()) {
      String documentDescription =
          "Info: ${item['Info']}\nDate: ${item['Date']}";
      documentList.add(
        Card(
          color: appColorScheme.secondaryContainer,
          child: ListTile(
            title: Text(item["Document Type"]),
            subtitle: Text(documentDescription),
            isThreeLine: true,
            trailing: ElevatedButton(
              child: const Text("Open"),
              onPressed: () async {
                final Directory tempDir = await getApplicationCacheDirectory();
                final String filePath =
                    "${tempDir.path}/${item['Document']}.pdf";

                await sc.downloadFile(item["DocumentLink"], filePath);

                try {
                  await OpenFilex.open(filePath);
                } catch (e) {
                  throw ("Error occured when launching file: $e");
                }
              },
            ),
          ),
        ),
      );
    }

    return ExpandableCard(
      title: const Text("Student Documents"),
      children: documentList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: _getStudentInfo(
              widget.studentConnect,
              widget.appColorScheme,
            ),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              List<Widget> children = [];
              if (snapshot.hasData) {
                children = snapshot.data;
              } else if (snapshot.hasError) {
                return Text("An Error Occured: ${snapshot.error}");
              } else {
                return const CustomProgressIndicator(
                  subwidget: Text("Loading Student Info"),
                );
              }

              return Column(children: children);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: _fetchStudentDocuments(
              widget.studentConnect,
              widget.appColorScheme,
            ),
            initialData: const CustomProgressIndicator(
              subwidget: Text("Loading Student Documents"),
            ),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return snapshot.data;
            },
          ),
          // child: Column(children: studentDocumentList),
        ),
      ],
    );
  }
}
