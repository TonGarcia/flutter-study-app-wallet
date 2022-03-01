import 'package:app/config.dart';
import 'package:app/models/user_data.dart';
import 'package:app/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class PocCollateralizePage extends StatefulWidget {
  const PocCollateralizePage({Key? key}) : super(key: key);

  @override
  State<PocCollateralizePage> createState() => _PocCollateralizePageState();
}

class _PocCollateralizePageState extends State<PocCollateralizePage> {
  late Client httpClient;
  late Web3Client ethClient;
  late num _amountEther = 0;
  late num _maxStable = 0;
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
                          padding: const EdgeInsets.only(left: 90.0),
                          child:
                          Text(
                            'Balance: $_amountEther ETH',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        IconButton(
                          onPressed: (){
                            // updateBalance();
                          },
                          icon: const Icon(Icons.refresh),
                          color: Colors.blue,
                        )
                      ],
                    ),
                    Container(
                        padding: const EdgeInsets.all(20.0),
                        child: TextField(
                          maxLines: null,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            // 1*10^18 weis means 1 ether
                            // TODO The supply of ethereum is flexible so need some provide to update it available range
                            FilteringTextInputFormatter.allow(RegExp(r'^[\d+]{0,8}\.?[\d*]{0,18}')),
                          ],
                          decoration: const InputDecoration(
                            hintText: 'Deposit ETH (collateral)',
                          ),
                        )
                    ),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.only(right: 20.0))
                      ),
                      onPressed: () { },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text('Max $_maxStable USDM'),
                      )
                    ),
                    Container(
                        padding: const EdgeInsets.all(20.0),
                        child: TextField(
                          maxLines: null,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^[\d+]{0,10}\.?[\d*]{0,2}')),
                          ],
                          decoration: const InputDecoration(
                            hintText: 'Generate USD stable coin',
                          ),
                        )
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 15.0, top: 20.0),
                            child: Text(
                              'Vault changes',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          )
                        ]
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                            padding: const EdgeInsets.only(left: 15.0, top: 20.0),
                            child: Text(
                              'Collateral Locked',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                        Container(
                            width: screenWidth*0.72,
                            padding: const EdgeInsets.only(left: 15.0, top: 20.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '$_amountEther ETH ->  1.000 ETH',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            )
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 15.0, top: 20.0),
                          child: Text(
                            'Collateralization Ratio',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                        Container(
                            width: screenWidth*0.66,
                            padding: const EdgeInsets.only(left: 15.0, top: 20.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '0.00% ->  X%',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            )
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 15.0, top: 20.0),
                          child: Text(
                            'Liquidation Price',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                        Container(
                            width: screenWidth*0.72,
                            padding: const EdgeInsets.only(left: 15.0, top: 20.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '\$0.00 ->  \$0.00',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            )
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 15.0, top: 20.0),
                          child: Text(
                            'Vault USDM Debt',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                        Container(
                            width: screenWidth*0.72,
                            padding: const EdgeInsets.only(left: 15.0, top: 20.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '0.00 USDM ->  0.00 USDM',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            )
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 15.0, top: 20.0),
                          child: Text(
                            'Available to withdraw',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                        Container(
                            width: screenWidth*0.67,
                            padding: const EdgeInsets.only(left: 15.0, top: 20.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '0.00 ETH ->  0.00 ETH',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            )
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 15.0, top: 20.0),
                          child: Text(
                            'Available to generate',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                        Container(
                            width: screenWidth*0.67,
                            padding: const EdgeInsets.only(left: 15.0, top: 20.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '0.00 USDM ->  0.00 USDM',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            )
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 25.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color(0xFF282A36),
                                      Color(0xFF204799),
                                      Color(0xFF1260CD),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(16.0),
                                primary: Colors.white,
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                //_userWalletData.loadWallet(_seedPhraseController.text);
                              },
                              icon: const Icon(Icons.star),
                              label: const Text('Open collateral position'),
                            ),
                          ],
                        ),
                      ),
                    )

                  ]
              ),
            )
        )
    );
  }

}