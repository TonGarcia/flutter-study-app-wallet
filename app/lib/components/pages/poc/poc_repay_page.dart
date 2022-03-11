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
  late num _balanceUSDM = 0.00;
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

  Future<void> updateBalance() async {

  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        reverse: true,
        child: Center(
          child: Column(
              children: <Widget>[
                Row(
                    children: [
                      Container(
                        width: screenWidth*0.8,
                        padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                        child:
                        Text(
                          'Balance (USDM): US\$ $_balanceUSDM',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      IconButton(
                        padding: const EdgeInsets.only(top: 10.0),
                        onPressed: (){
                          updateBalance();
                        },
                        icon: const Icon(Icons.refresh),
                        color: Colors.blue,
                      )
                    ]
                )
              ]
          )
        )
      )
    );
  }

}