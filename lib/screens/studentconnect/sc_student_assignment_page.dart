import "package:flutter/material.dart";

import "../../widgets/expandable_card.dart";
import "../../widgets/custom_progress_indicator.dart";

import "../../utilities/studentconnect.dart";

class StudentAssignmentContainer extends StatefulWidget {
  final StudentConnect studentConnect;
  final ColorScheme appColorScheme;
  const StudentAssignmentContainer({
    super.key,
    required this.studentConnect,
    required this.appColorScheme,
  });

  @override
  State<StudentAssignmentContainer> createState() =>
      _StudentAssignmentContainerState();
}

class _StudentAssignmentContainerState extends State<StudentAssignmentContainer>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<List<ExpandableCard>> _getCourseInfo(
      StudentConnect sc, ColorScheme appColorScheme) async {
    if (!sc.isLoggedIn) throw Exception("Not Logged In");

    List<ExpandableCard> courseInfoList = [];

    List<String> courseHeadingList = [];
    List<List<String>> courseSubHeadingList = [];
    for (final course in await sc.fetchAssignments()) {
      String itemLabel = "${course['course_heading']['course_name']}";

      String gradeInfo = "${course['course_overview']['letter_grade']}";

      if (course["course_overview"]["has_percentage"]) {
        gradeInfo += " (${course['course_overview']['percentage']}%)";
      }

      List<String> itemSubtitle = [
        "${course['course_overview']['teacher_name']}",
        gradeInfo,
      ];

      courseHeadingList.add(itemLabel);
      courseSubHeadingList.add(itemSubtitle);
    }

    List<List<Card>> courseAssignmentList = [];
    for (final course in await sc.fetchAssignments()) {
      List<Card> assignmentList = [];
      for (final item in course["assignments"]) {
        double assignmentScore = double.tryParse(item["Score"]) ?? 0.0;
        double assignmentTotalPoints =
            double.tryParse(item["PtsPossible"]) ?? 0.0;

        double assignmentPercentage = double.parse(
          (assignmentScore / assignmentTotalPoints * 100).toStringAsFixed(2),
        );

        List<Text> trailingWidgets = [
          Text(
            "${item['Score']}/${item['PtsPossible']}",
            style: const TextStyle(fontSize: 17),
          ),
          if (item["NotGraded"] != "true") Text("$assignmentPercentage%"),
          if (item["NotGraded"] == "true")
            Text(
              "Not Graded",
              style: TextStyle(color: appColorScheme.error),
              textAlign: TextAlign.center,
            ),
        ];

        String subtitle = item["Date Due"];

        if (item["Comments"].isNotEmpty) {
          subtitle += "\nNote: \"${item['Comments']}\"";
        }

        assignmentList.add(
          Card(
            color: appColorScheme.secondaryContainer,
            child: ListTile(
              title: Text(item["Assignment"]),
              subtitle: Text(subtitle),
              isThreeLine: item["Comments"].isNotEmpty,
              trailing: SizedBox(
                width: 65.0,
                height: 50.0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: trailingWidgets,
                  ),
                ),
              ),
            ),
          ),
        );
      }
      courseAssignmentList.add(assignmentList);
    }

    for (final (index, course) in courseHeadingList.indexed) {
      courseInfoList.add(
        ExpandableCard(
          title: Text(course),
          subtitle: Row(
            children: [
              Expanded(
                child: Text(
                  courseSubHeadingList[index][0],
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: Text(
                  courseSubHeadingList[index][1],
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          children: courseAssignmentList.elementAt(index),
        ),
      );
    }

    return courseInfoList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getCourseInfo(widget.studentConnect, widget.appColorScheme),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        List<ExpandableCard> courseList = [];
        if (snapshot.hasData) {
          courseList = snapshot.data;
        } else if (snapshot.hasError) {
          return Text("An Error Occured: ${snapshot.error}");
        } else {
          return const CustomProgressIndicator(
            subwidget: Text("Loading Assignments"),
          );
        }

        return Column(
          children: courseList,
        );
      },
    );
  }
}
