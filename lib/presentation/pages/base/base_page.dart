import 'package:flutter/material.dart';
import 'package:passkey_example/presentation/shared_widgets/loading_layer.dart';

class BasePage extends StatelessWidget {
  const BasePage({
    required this.child,
    super.key,
    this.title = 'Passkey Example',
    this.showLoading = false,
  });

  final Widget child;
  final String title;
  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    return LoadingLayer(
      visible: showLoading,
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: kToolbarHeight),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
