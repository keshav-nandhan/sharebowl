import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharebowl/models/users.dart';

class WalletPage extends StatefulWidget {
  final Users user;
  const WalletPage({
    super.key,
    required this.user,
  });

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
