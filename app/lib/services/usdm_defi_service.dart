import 'dart:io';
import 'package:app/models/user_data.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:app/config.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class USDMDeFiService {

  // Integration
  String rpcUrl = Config.ethereumUrl;
  String wsUrl = Config.ethereumSocketUrl;
  late Client httpClient;
  late Web3Client web3Client;
  late UserData _userWalletData;

  // Contract data
  final EthereumAddress contractAddress = Config.usdmAddress();
  late File abiFile;
  late String abiCode;
  late DeployedContract contract;

  // Contract events & functions
  late ContractEvent transferEvent;
  late ContractFunction balanceFunction, calcProvidedRatioFunction,
                        estimateLiquidationPriceFunction, getETHUSDFunction,
                        getCollateralsEthOfFunction;

  USDMDeFiService() {
    httpClient = Client();
    web3Client = Web3Client(rpcUrl, httpClient);
    const autoGenerateWallet = false;
    _userWalletData = UserData(autoGenerateWallet);
    setupContract();
  }

  void setupContract() async {
    // abiFile = await Config.abiUsdm();
    // abiCode = await abiFile.readAsString();
    abiCode = await rootBundle.loadString('assets/references/usdm/MintDollar-abi.json');
    contract = DeployedContract(ContractAbi.fromJson(abiCode, 'USDM'), contractAddress);

    // extracting functions and events
    transferEvent = contract.event('Transfer');
    balanceFunction = contract.function('balanceOf');
    calcProvidedRatioFunction = contract.function('calcProvidedRatio');
    estimateLiquidationPriceFunction = contract.function('estimateLiquidationPrice');
    getCollateralsEthOfFunction = contract.function('getCollateralsEthOf');
    getETHUSDFunction = contract.function('getETHUSD');
  }

  void subscribeTransferEvent() {
    // listen for the Transfer event when it's emitted by the contract above
    final subscription = web3Client
        .events(FilterOptions.events(contract: contract, event: transferEvent))
        .take(1)
        .listen((event) {
          final decoded = transferEvent
                          .decodeResults(event.topics as List<String>,
                                         event.data as String);

          final from = decoded[0] as EthereumAddress;
          final to = decoded[1] as EthereumAddress;
          final value = decoded[2] as BigInt;
          print('$from sent $value MetaCoins to $to');
    });
  }

  Future<List> getBalance() {
    return web3Client.call(
        contract: contract,
        function: balanceFunction,
        params: [_userWalletData.publicAddress]
    );
  }

}