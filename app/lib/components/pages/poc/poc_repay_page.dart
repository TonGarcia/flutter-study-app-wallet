import 'package:app/config.dart';
import 'package:app/models/user_data.dart';
import 'package:app/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class PocRepayPage extends StatefulWidget {
  const PocRepayPage({Key? key}) : super(key: key);

  @override
  State<PocRepayPage> createState() => _PocRepayPageState();
}

class _PocRepayPageState extends State<PocRepayPage> {
  late Client httpClient;
  late Web3Client ethClient;
  late UserData _userWalletData;
  final WalletService _walletService = WalletService();

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(Config.ethereumUrl, httpClient);
    bool autoGenerateWallet = true;
    _userWalletData = UserData(autoGenerateWallet);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return const SingleChildScrollView(
        reverse: true,
        child: Center()
    );
  }

}