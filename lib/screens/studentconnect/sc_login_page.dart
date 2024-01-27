import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:biometric_storage/biometric_storage.dart";

import "sc_main_page.dart";
import "../../widgets/custom_progress_indicator.dart";

import "../../utilities/studentconnect.dart";

class StudentConnectLoginPage extends StatefulWidget {
  const StudentConnectLoginPage({super.key});

  @override
  State<StudentConnectLoginPage> createState() =>
      _StudentConnectLoginPageState();
}

class _StudentConnectLoginPageState extends State<StudentConnectLoginPage> {
  final _studentConnect = StudentConnect();

  final studentIdController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscureText = true;

  CanAuthenticateResponse _authSupport = CanAuthenticateResponse.statusUnknown;

  void showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }

  void handleAuthException(AuthException e) {
    if (e.code == AuthExceptionCode.userCanceled) {
      showSnackBar("Biometric verification cancelled");
      return;
    } else {
      showSnackBar("An error occurred: ${e.message}");
      throw e;
    }
  }

  Future<void> writeStorage(
    BiometricStorageFile storageObject,
    Map<String, dynamic> data,
  ) async {
    if (data.isEmpty) return;

    try {
      await storageObject.write(jsonEncode(data));
    } on AuthException catch (e) {
      handleAuthException(e);
    } catch (e) {
      showSnackBar("An unexpected error occured: ${e.toString()}");
      rethrow;
    }
  }

  Future<String> readStorage(BiometricStorageFile storageObject) async {
    String rawJson = "";

    try {
      rawJson = await storageObject.read() ?? "";
    } on AuthException catch (e) {
      handleAuthException(e);
    } catch (e) {
      showSnackBar("An unexpected error occured: ${e.toString()}");
      rethrow;
    }

    return rawJson;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> login() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Center(
          child: CustomProgressIndicator(
            subwidget: Text("Logging in"),
          ),
        );
      },
    );
    try {
      await _studentConnect.login(
        studentIdController.text,
        passwordController.text,
      );
    } catch (e) {
      if (!context.mounted) return;
      showSnackBar(e.toString());

      Navigator.of(context).pop();
      return;
    }

    if (!context.mounted) return;
    Navigator.of(context).pop();

    studentIdController.clear();
    passwordController.clear();

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StudentConnectResult(),
        settings: RouteSettings(
          arguments: _studentConnect,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    BiometricStorage().canAuthenticate().then(
      (CanAuthenticateResponse response) {
        _authSupport = response;
      },
    );
  }

  @override
  void dispose() {
    studentIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: studentIdController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: "Student ID",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: _obscureText,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    onPressed: _togglePasswordVisibility,
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    tooltip: "Toggle Password Visibility",
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                await login();
              },
              child: const Text("Login to Student Connect"),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  if (_authSupport != CanAuthenticateResponse.success &&
                      _authSupport != CanAuthenticateResponse.statusUnknown) {
                    showSnackBar(
                        "Device not supported: ${_authSupport.toString()}");
                    return;
                  }

                  BiometricStorageFile authStorage =
                      await BiometricStorage().getStorage("user_creds");

                  //TODO - Temporary variable for testing, later move to a settings page
                  Map<String, dynamic> userData = {
                    "studentID": "SavedID",
                    "studentPassword": "SavedPassword",
                  };

                  await writeStorage(
                      authStorage, userData); // Require fingerprint

                  Map<String, dynamic> storedCreds = {};

                  final rawJson =
                      await readStorage(authStorage); // Require fingerprint

                  try {
                    storedCreds = jsonDecode(rawJson);
                  } on FormatException {
                    showSnackBar(
                        "Error reading credientials (empty or corrupted)");
                    return;
                  } catch (e) {
                    showSnackBar(
                        "An unexpected error occured: ${e.toString()}");
                    rethrow;
                  }

                  if (storedCreds.isEmpty) {
                    showSnackBar("No account detail saved");
                    return;
                  }

                  if (storedCreds.containsKey("studentID") &&
                      storedCreds.containsKey("studentPassword")) {
                    studentIdController.text = storedCreds["studentID"];
                    passwordController.text = storedCreds["studentPassword"];
                    await login();
                  } else {
                    showSnackBar(
                        "Saved account corrupted. Add new credentials");
                  }
                },
                child: const Text("Login With Biometrics"),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings),
                  ),
                ),
              ),
            ],
          ),
          ElevatedButton(
              onPressed: () async {
                BiometricStorageFile authStorage =
                    await BiometricStorage().getStorage("user_creds");

                try {
                  await authStorage.delete();
                } catch (e) {
                  showSnackBar("An unexpected error occured: ${e.toString()}");
                  rethrow;
                }

                showSnackBar("Credientials Cleared");
              },
              child: const Text("Clear Credientials"))
        ],
      ),
    );
  }
}
