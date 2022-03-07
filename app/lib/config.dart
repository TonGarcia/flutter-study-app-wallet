import 'dart:io';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:web3dart/web3dart.dart';
import 'package:path/path.dart' show join, dirname;

class Config {
  static const String appTitle = 'My Easy Wallet';
  static const String rinkebyUrl = 'https://rinkeby.infura.io/v3/208dc164656e4276967971e6614a44d0';
  static const String rinkebySocketUrl = 'wss://rinkeby.infura.io/v3/208dc164656e4276967971e6614a44d0';
  static const String ethereumUrl = rinkebyUrl;
  static const String ethereumSocketUrl = rinkebySocketUrl;
  static const String noWalletStr = 'No wallet yet';
  static const String noSeedPhraseStr = 'No seed wallet yet';

  static EthereumAddress usdmAddress() {
    return EthereumAddress.fromHex('0xd8b453d37B90Fb78a9DFcFBcFec37321b0093282');
  }

  static Future<String> abiUsdm() async {
    final data = await rootBundle.loadString('assets/references/usdm/MintDollar-abi.json');
    return data;
  }
}