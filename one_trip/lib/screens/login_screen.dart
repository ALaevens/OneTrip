import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_trip/api/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<bool> _isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportContraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: viewportContraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox.square(
                    dimension: 150,
                    child: SvgPicture.asset(
                      "assets/images/desktop.svg",
                      fit: BoxFit.contain,
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            LayoutBuilder(builder: (builder, constraints) {
                              return ToggleButtons(
                                isSelected: _isSelected,
                                constraints: BoxConstraints.expand(
                                    width: constraints.maxWidth / 2 - 8,
                                    height: 30),
                                selectedBorderColor:
                                    Theme.of(context).colorScheme.primary,
                                onPressed: (index) {
                                  setState(() {
                                    for (int i = 0;
                                        i < _isSelected.length;
                                        i++) {
                                      _isSelected[i] = (i == index);
                                    }
                                  });
                                },
                                children: const [
                                  Text("Log In"),
                                  Text("Sign Up")
                                ],
                              );
                            }),
                            _isSelected[0]
                                ? const LoginForm()
                                : const SignupForm()
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _stayLoggedIn = false;
  bool _tryingLogin = false;
  final _usernameController = TextEditingController(text: "");
  final _passwordController = TextEditingController(text: "");

  void tryLogIn(bool save) async {
    setState(() {
      _tryingLogin = true;
    });

    String tok =
        await getToken(_usernameController.text, _passwordController.text);

    if (tok == "") {
      showError("That Username / Password combination does not exist.");
      setState(() {
        _tryingLogin = false;
      });
      return;
    }

    if (save) {
      const storage = FlutterSecureStorage();
      storage.write(key: "token", value: tok);
    }

    if (mounted) {
      await Navigator.pushReplacementNamed(context, "/home");
    }
  }

  void trySavedToken() async {
    setState(() {
      _tryingLogin = true;
    });

    // get token from storage
    const storage = FlutterSecureStorage();
    final String? token = await storage.read(key: "token");
    if (token == null) {
      setState(() {
        _tryingLogin = false;
      });

      return;
    }

    // check the stored token still works
    final bool stillValid = await testToken(token);
    if (!stillValid) {
      storage.delete(key: "token");

      setState(() {
        _tryingLogin = false;
      });
      return;
    }

    // store the token in a singleton to avoid repeated storage accesses
    final TokenSingleton s = TokenSingleton();
    s.setToken(token);

    if (mounted) {
      await Navigator.pushReplacementNamed(context, "/home");
    }
  }

  void showError(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        content: Text(text),
        action: SnackBarAction(
          textColor: Theme.of(context).colorScheme.onError,
          label: "Dismiss",
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    trySavedToken();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: _usernameController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(hintText: "Username"),
          ),
          TextFormField(
            controller: _passwordController,
            textInputAction: TextInputAction.done,
            obscureText: true,
            decoration: const InputDecoration(hintText: "Password"),
            onFieldSubmitted: (value) => tryLogIn(_stayLoggedIn),
          ),
          Row(
            children: [
              const Text("Stay Logged In:"),
              Checkbox(
                value: _stayLoggedIn,
                onChanged: (value) {
                  setState(() {
                    _stayLoggedIn = value!;
                  });
                },
              )
            ],
          ),
          ElevatedButton(
            onPressed: !_tryingLogin ? () => tryLogIn(_stayLoggedIn) : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: _tryingLogin
                  ? [
                      const Text("Log In"),
                      const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    ]
                  : const [
                      Text("Log In"),
                    ],
            ),
          )
        ],
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _usernameController = TextEditingController(text: "");
  final _passwordController = TextEditingController(text: "");
  final _firstnameController = TextEditingController(text: "");
  final _lastnameController = TextEditingController(text: "");

  void showError(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        content: Text(text),
        action: SnackBarAction(
          textColor: Theme.of(context).colorScheme.onError,
          label: "Dismiss",
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  void trySignUpLogin() async {
    String firstName = _firstnameController.text;
    String lastName = _lastnameController.text;
    String userName = _usernameController.text;
    String password = _passwordController.text;

    if (firstName == "" || lastName == "" || userName == "" || password == "") {
      showError("All fields must be populated");
      return;
    }

    String errors = await signup(firstName, lastName, userName, password);

    if (errors != "") {
      showError(errors);
      return;
    }

    String tok = await getToken(userName, password);
    if (tok == "") {
      showError("That Username / Password combination does not exist.");
      return;
    }

    if (mounted) {
      await Navigator.pushReplacementNamed(context, "/home");
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  controller: _firstnameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(hintText: "First Name"),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: TextFormField(
                  controller: _lastnameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(hintText: "Last Name"),
                ),
              )
            ],
          ),
          TextFormField(
            controller: _usernameController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(hintText: "Username"),
          ),
          TextFormField(
            controller: _passwordController,
            textInputAction: TextInputAction.done,
            obscureText: true,
            decoration: const InputDecoration(hintText: "Password"),
            onFieldSubmitted: (value) async => trySignUpLogin(),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              trySignUpLogin();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const [Text("Sign up & Log in")],
            ),
          )
        ],
      ),
    );
  }
}
