import 'dart:io';
import 'dart:async' show Future;
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
    return EthereumAddress.fromHex('0xf451659CF5688e31a31fC3316efbcC2339A490Fb');
  }

  static Future<File> abiUsdm() async {
    String abiPath = 'assets/references/usdm/MintDollar-abi.json';
    // String abi = await rootBundle.loadString('assets/references/usdm/MintDollar-abi.json');
    // return File(join(dirname(Platform.script.path), abi));
    // return File('assets/references/usdm/MintDollar-abi.json');
    // return File(join(dirname(Platform.script.path), abiPath));
    // return File('assets/references/usdm/MintDollar-abi.json');
    // return File('assets/references/usdm/MintDollar-abi.json');
    // return File('assets/ethereum.png');
    // Directory appTempDir = await getTemporaryDirectory();
    // String appDocPath = appTempDir.path;
    // return File('$appDocPath/assets/references/usdm/MintDollar-abi.json');
    // '${(await getTemporaryDirectory()).path}/$path'
    // return File(rootBundle.load('assets/$abiPath'));

    final path = await rootBundle.loadString('assets/references/usdm/MintDollar-abi.json');
    return File(path);
  }
}