import 'package:app/config.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:hex/hex.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

abstract class WalletAddressService {
  String generateMnemonic();
  Future<num> getBalance(String privateKey);
  Future<String> getPrivateKey(String mnemonic);
  Future<EthereumAddress> getPublicKey(String privateKey);
  Future<List<dynamic>> query(String functionName, List<dynamic> args);
}

class WalletAddress implements WalletAddressService {

  final Client _httpClient = Client();
  late Web3Client _ethClient;

  WalletAddress() {
    _ethClient = Web3Client(Config.rinkebyUrl, _httpClient);
  }

  @override
  String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  @override
  Future<String> getPrivateKey(String mnemonic) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final master = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
    final privateKey = HEX.encode(master.key);
    return privateKey;
  }

  @override
  Future<EthereumAddress> getPublicKey(String privateKey) async {
    final privateHex = EthPrivateKey.fromHex(privateKey);
    final address = await privateHex.extractAddress();
    return address;
  }

  @override
  Future<num> getBalance(String privateKey) async {
    final credentials = EthPrivateKey.fromHex(privateKey);
    EtherAmount balance = await _ethClient.getBalance(credentials.address);
    return balance.getValueInUnit(EtherUnit.ether);
  }

  @override
  Future<List> query(String functionName, List args) {
    // TODO: implement query over smart contract
    throw UnimplementedError();
  }
}