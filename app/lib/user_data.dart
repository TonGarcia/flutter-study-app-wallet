import 'dart:async';
import 'package:app/config.dart';
import 'package:app/wallet_address_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/credentials.dart';

class UserData {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String walletPublicKey = '', walletPrivateKey = '', publicAddress = '', seedPhrase = '';
  late WalletAddress walletService;

  UserData();

  void setUserDefaults(String walletPublicKey, String walletPrivateKey,
                       String publicAddress, String seedPhrase) async {

    final SharedPreferences prefs = await _prefs;
    prefs.setString('walletPublicKey', walletPublicKey);
    prefs.setString('walletPrivateKey', walletPrivateKey);
    prefs.setString('publicAddress', publicAddress);
    prefs.setString('seedPhrase', seedPhrase);

  }

  void loadUserData(bool autoGenerateWallet) {
    walletService = WalletAddress();

    // TODO load from Cloud if NULL loads from local
    loadUserDefaults();

    // create wallet if no defaults
    if(autoGenerateWallet == true &&
        (walletPublicKey == '' || walletPrivateKey == '' ||
        publicAddress == '' || seedPhrase == '')
    ) {
      createWallet();
    }

  }

  void loadUserDefaults() async {
    final SharedPreferences prefs = await _prefs;
    walletPublicKey = prefs.getString('walletPublicKey') ?? '';
    walletPrivateKey = prefs.getString('walletPrivateKey') ?? '';
    publicAddress = prefs.getString('publicAddress') ?? Config.noWalletStr;
    seedPhrase = prefs.getString('seedPhrase') ?? Config.noSeedPhraseStr;
  }

  void createWallet() async {
    seedPhrase = walletService.generateMnemonic();
    final privateKey = await walletService.getPrivateKey(seedPhrase);
    final publicKey = await walletService.getPublicKey(privateKey);
    walletPrivateKey = privateKey;
    walletPublicKey = publicKey.toString();
    publicAddress = publicKey.toString();
    setUserDefaults(walletPublicKey, walletPrivateKey, publicAddress, seedPhrase);
  }

  Future<num> getBalance() async {
    return await walletService.getBalance(walletPrivateKey);
  }

}