import 'package:flutter/material.dart';
import 'package:themoviedb/library/widgets/inherited/provider.dart';
import 'package:themoviedb/ui/widgets/auth/auth_model.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            style: TextStyle(color: Colors.white),
            "Login to your acccount",
          ),
        ),
      ),
      body: ListView(children: [_FormWidget(), _HeaderWidget()]),
    );
  }
}

class _FormWidget extends StatelessWidget {
  final textStyle = TextStyle(fontSize: 16, color: Color(0xFF212529));
  final inputDecoration = InputDecoration(
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    isCollapsed: true,
  );

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.read<AuthModel>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ErrorMessageWidget(),
          Text("Username", style: textStyle),
          SizedBox(height: 5),
          TextField(
            controller: model?.loginTextController,
            decoration: inputDecoration,
          ),
          SizedBox(height: 20),
          Text("Password", style: textStyle),
          SizedBox(height: 5),
          TextField(
            controller: model?.passwordTextController,
            decoration: inputDecoration,
            obscureText: true,
          ),
          SizedBox(height: 5),
          Row(
            children: [
              const _AuthButtonWidget(),
              TextButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "Reset password",
                  style: TextStyle(color: Color.fromRGBO(1, 180, 228, 1)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<AuthModel>(context);
    final onPressed =
        model?.isCanAuth == true ? () => model?.auth(context) : null;
    final child =
        model?.isAuthProgress == true
            ? const SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
            : const Text('Login', style: TextStyle(color: Colors.black));
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          Color.fromRGBO(57, 27, 225, 1),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
        ),
      ),
      child: child,
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final errorMessage =
        NotifierProvider.watch<AuthModel>(context)?.errorMessage;
    if (errorMessage == null) {
      return const SizedBox.shrink();
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Text(
          errorMessage,
          style: const TextStyle(fontSize: 17, color: Colors.red),
        ),
      );
    }
  }
}

class _HeaderWidget extends StatelessWidget {
  final textStyle = TextStyle(fontSize: 16, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            softWrap: true,
            "In order to use the editing and rating capabilities of TMDB, "
            "as well as get personal recommendations you will need to login to your "
            "account. If you do not have an account, registering for an account "
            "is free and simple. ",
            style: textStyle,
          ),
          Row(
            children: [
              SizedBox(
                height: 25,
                child: TextButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Click here",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(1, 180, 228, 1),
                    ),
                  ),
                ),
              ),
              Text(" to get started.", style: textStyle),
            ],
          ),
          SizedBox(height: 16),
          Text(
            "If you signed up but didn`t get your verification email.",
            style: textStyle,
          ),
          Row(
            children: [
              SizedBox(
                height: 25,
                child: TextButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Click here",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(1, 180, 228, 1),
                    ),
                  ),
                ),
              ),
              Text(" to have it resent.", style: textStyle),
            ],
          ),
        ],
      ),
    );
  }
}
