import 'package:app/components/widgets/alert.dart';
import 'package:app/config.dart';
import 'package:app/models/user_data.dart';
import 'package:app/services/usdm_defi_service.dart';
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
  late USDMDeFiService deFi;
  late Client httpClient;
  late Web3Client ethClient;
  late UserData _userWalletData;
  final WalletService _walletService = WalletService();

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    deFi = USDMDeFiService();
    ethClient = Web3Client(Config.ethereumUrl, httpClient);
    bool autoGenerateWallet = true;
    _userWalletData = UserData(autoGenerateWallet);
  }

  Future<void> updateBalance() async {
    setState(() {
      deFi.getBalance().then((result){
        _balanceUSDM = result[0].toDouble()/100;
      }).catchError((handleError) {
        Alert.show(context, "Contract returned an exception", <Widget>[Text(handleError.toString())]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String dropdownValue = "Select a collateral to repay";
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
                ),
                Row(
                  children: [
                    Container(
                      width: screenWidth*0.8,
                      padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                      child: DropdownButton<String>(
                          value: dropdownValue,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          items: <String>[dropdownValue]
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList()
                        )
                    )
                  ],
                )
              ]
          )
        )
      )
    );
  }

}