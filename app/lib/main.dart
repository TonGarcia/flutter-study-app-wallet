import 'package:app/config.dart';
import 'package:app/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:app/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
// import 'black.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Config.appTitle,
      debugShowCheckedModeBanner: false, // removes the debug label
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blueGrey, // primaryBlack, //Colors.teal,
      ),
      home: const MyHomePage(title: Config.appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late num _amountEther = 0;
  late UserData _userWalletData;
  late num _smartContractBalance = 0;

  late Client httpClient;
  late Web3Client ethClient;

  final WalletService _walletService = WalletService();
  final TextEditingController _contractAddress = TextEditingController();
  final TextEditingController _amountEditorController = TextEditingController();
  final TextEditingController _targetAddressEditorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(Config.rinkebyUrl, httpClient);
    bool autoGenerateWallet = true;
    _userWalletData = UserData(autoGenerateWallet);
  }

  Future<DeployedContract> loadLocalContract() async {
    String abi = await rootBundle.loadString('assets/easy_wallet_abi.json');
    String contractAddress = "...";
    final contract = DeployedContract(ContractAbi.fromJson(abi, "CoinName"), EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<dynamic> query(String functionName, List<dynamic> args) async {
    // final contract = await loadLocalContract();
  }

  Future<void> updateBalance() async {
    num amountEther = await _userWalletData.getBalance();
    setState(() {
      _amountEther = amountEther;
    });
  }

  Future<void> updateSmartContractBalance() async {
    num amountSmartContract = await _userWalletData.getSmartContractBalance();
    setState(() {
      _smartContractBalance = amountSmartContract;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title)
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                width: 150,
                child: Image(
                  image: AssetImage('assets/ethereum.png'),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 300,
                    padding: const EdgeInsets.only(left: 90.0),
                    child:
                    Text(
                      '$_amountEther',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  IconButton(
                    onPressed: (){
                      updateBalance();
                    },
                    icon: const Icon(Icons.refresh),
                    color: Colors.blue,
                  )
                ],
              ),
              Text(
                'network: rinkeby',
                style: Theme.of(context).textTheme.headline6,
              ),
              Row(
                children: [
                  Container(
                    width: 300,
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Text(_userWalletData.seedPhrase,
                        style: const TextStyle(fontSize: 15.0),
                        textAlign: TextAlign.center),
                  ),
                  const SizedBox(width: 20.0),
                  IconButton(
                    onPressed: (){
                      Clipboard.setData(ClipboardData(text: _userWalletData.seedPhrase));
                    },
                    icon: const Icon(Icons.content_copy),
                    color: Colors.blue,
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 300,
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Text(_userWalletData.publicAddress,
                        style: const TextStyle(fontSize: 25.0),
                        textAlign: TextAlign.center),
                  ),
                  const SizedBox(width: 20.0),
                  IconButton(
                    onPressed: (){
                      Clipboard.setData(ClipboardData(text: _userWalletData.publicAddress));
                    },
                    icon: const Icon(Icons.content_copy),
                    color: Colors.blue,
                  )
                ],
              ),
              Container(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    maxLines: null,
                    controller: _targetAddressEditorController,
                    decoration: const InputDecoration(
                      hintText: 'Set (ETHEREUM RINKEBY) public address to send funds',
                    ),
                    keyboardType: TextInputType.multiline,
                  )
              ),
              Container(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    maxLines: null,
                    controller: _amountEditorController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      // 1*10^18 weis means 1 ether
                      // TODO The supply of ethereum is flexible so need some provide to update it available range
                      FilteringTextInputFormatter.allow(RegExp(r'^[\d+]{0,8}\.?[\d*]{0,18}')),
                    ],
                    decoration: const InputDecoration(
                      hintText: 'Amount of ETHEREUM RINKEBY to be sent',
                    ),
                  )
              ),
              // SEND BUTTON
              ClipRRect(
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
                        final amountToSend = _amountEditorController.text;
                        final ethereumToAddress = _targetAddressEditorController.text;
                        final validEthereumAddress = _walletService.validatePublicAddress(ethereumToAddress);

                        if(amountToSend.isEmpty || ethereumToAddress.isEmpty || validEthereumAddress.isNotEmpty) {
                          String contentMsg = "Check the values you entered and try again";

                          if(validEthereumAddress.isNotEmpty) contentMsg = validEthereumAddress;

                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.blueGrey,
                                title: const Text("Invalid values"),
                                content: Text(contentMsg),
                                actions: [
                                  MaterialButton(
                                    child: const Text("OK"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }
                                  )
                                ]
                              );
                            }
                          );

                          return;
                        }

                        final transactionDTO = TransactionDTO(
                            _userWalletData.walletPrivateKey,
                            _userWalletData.walletPublicKey,
                            ethereumToAddress,
                            amountToSend
                        );

                        _walletService.sendEther(transactionDTO);

                        print('amountToSend: ' + amountToSend);
                        print('ethereumToAddress: ' + ethereumToAddress);
                      },
                      icon: const Icon(Icons.call_made_outlined),
                      label: const Text('Send transaction'),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)
              ),
              // LOAD SMART CONTRACT BALANCE
              Container(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    maxLines: null,
                    controller: _contractAddress,
                    decoration: const InputDecoration(
                      hintText: 'Smart Contract address on ETHEREUM RINKEBY to be tracked',
                    ),
                  )
              ),
              Row(
                children: [
                  Container(
                    width: 300,
                    padding: const EdgeInsets.only(left: 90.0),
                    child:
                    Text(
                      '$_smartContractBalance',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  IconButton(
                    onPressed: (){
                      updateBalance();
                    },
                    icon: const Icon(Icons.refresh),
                    color: Colors.blue,
                  )
                ],
              ),
              Text(
                'smart contract balance',
                style: Theme.of(context).textTheme.headline6,
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _createWallet,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.account_balance),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
