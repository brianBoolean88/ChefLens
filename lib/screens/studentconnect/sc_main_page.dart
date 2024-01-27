import "package:flutter/material.dart";

import "sc_student_assignment_page.dart";
import "sc_student_info_page.dart";

import "../../utilities/studentconnect.dart";

class StudentConnectResult extends StatefulWidget {
  const StudentConnectResult({super.key});

  @override
  State<StudentConnectResult> createState() => StudentConnectResultState();
}

class StudentConnectResultState extends State<StudentConnectResult>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      final studentConnect =
          ModalRoute.of(context)!.settings.arguments as StudentConnect;
      studentConnect.logout();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentConnect =
        ModalRoute.of(context)!.settings.arguments as StudentConnect;

    final appColorScheme = Theme.of(context).colorScheme;
    final PageController controller = PageController(initialPage: 0);

    return PopScope(
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          await studentConnect.logout();
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Student Connect"),
        ),
        body: PageView(
          controller: controller,
          physics: const ClampingScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: [
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: StudentAssignmentContainer(
                  studentConnect: studentConnect,
                  appColorScheme: appColorScheme,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: StudentInfoContainer(
                  studentConnect: studentConnect,
                  appColorScheme: appColorScheme,
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: "Assignments",
                icon: Icon(Icons.assignment),
              ),
              BottomNavigationBarItem(
                label: "Profile",
                icon: Icon(Icons.person),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: appColorScheme.primary,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
              controller.jumpToPage(index);
            },
          ),
        ),
      ),
    );
  }
}
