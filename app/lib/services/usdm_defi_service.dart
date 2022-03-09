import 'dart:ffi';
import 'dart:io';
import 'package:app/models/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:app/config.dart';
import 'package:web3dart/web3dart.dart';

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
                        getCollateralsEthOfFunction, estimateMaxMintableStable,
                        calcProvidedRatio;

  USDMDeFiService() {
    httpClient = Client();
    web3Client = Web3Client(rpcUrl, httpClient);
    const autoGenerateWallet = false;
    _userWalletData = UserData(autoGenerateWallet);
    setupContract();
  }

  void setupContract() async {
    abiCode = await Config.abiUsdm();
    contract = DeployedContract(ContractAbi.fromJson(abiCode, 'USDM'), contractAddress);

    // extracting functions and events
    transferEvent = contract.event('Transfer');
    balanceFunction = contract.function('balanceOf');
    calcProvidedRatioFunction = contract.function('calcProvidedRatio');
    estimateLiquidationPriceFunction = contract.function('estimateLiquidationPrice');
    getCollateralsEthOfFunction = contract.function('getCollateralsEthOf');
    getETHUSDFunction = contract.function('getETHUSD');
    estimateMaxMintableStable = contract.function('estimateMaxMintableStable');
    calcProvidedRatio = contract.function('calcProvidedRatio');
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
          debugPrint('$from sent $value MetaCoins to $to');
    });
  }

  Future<List> getBalance() {
    return web3Client.call(
        contract: contract,
        function: balanceFunction,
        params: [_userWalletData.publicAddress]
    );
  }

  Future<BigInt> maxMintableStable(BigInt lockedCollateral, BigInt globalPrice) async {
    final resp = await web3Client.call(
        contract: contract,
        function: estimateMaxMintableStable,
        params: [lockedCollateral, globalPrice]
    );

    return (resp[0] as BigInt);
  }

  Future<BigInt> providedRatio(BigInt collateral, BigInt globalPrice, BigInt expectedStable) async {
    final zero = BigInt.from(0);

    if(collateral == zero || expectedStable == zero) {
      return zero;
    }

    final resp = await web3Client.call(
        contract: contract,
        function: calcProvidedRatio,
        params: [collateral, globalPrice, expectedStable]
    );

    return (resp[0] as BigInt);
  }

  double formatStable(BigInt amount) {
    return amount.toDouble() / 100;
  }

}