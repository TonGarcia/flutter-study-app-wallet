import 'package:app/config.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:hex/hex.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/io.dart';

class TransactionDTO {
  late String privateKey;
  late String fromAddress;
  late String toAddress;
  late EtherUnit unit;
  late double amount;

  TransactionDTO(this.privateKey, this.fromAddress,
                 this.toAddress, this.unit, this.amount);
}

abstract class WalletAddressService {
  String generateMnemonic();
  EthPrivateKey getCredentials(String privateKey);
  Future<num> getBalance(String privateKey);
  Future<String> getPrivateKey(String mnemonic);
  Future<EthereumAddress> getPublicKey(String privateKey);
  Future<Transaction> prepareTransaction(TransactionDTO transaction);
  void sendEther(Credentials credentials, TransactionDTO transactionDTO);
  // Future<List<dynamic>> query(String functionName, List<dynamic> args);
}

class WalletService implements WalletAddressService {

  final Client _httpClient = Client();
  late Web3Client _ethClient;

  WalletService() {
    _ethClient = Web3Client(Config.rinkebyUrl, _httpClient, socketConnector: () {
      return IOWebSocketChannel.connect(Config.rinkebySocketUrl).cast<String>();
    });
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
  EthPrivateKey getCredentials(String privateKey) {
    return EthPrivateKey.fromHex(privateKey);
  }

  @override
  Future<Transaction> prepareTransaction(TransactionDTO transaction) async {
    EthereumAddress sender = EthereumAddress.fromHex(transaction.fromAddress);
    EthereumAddress receiver = EthereumAddress.fromHex(transaction.toAddress);
    EtherAmount etherAmount = EtherAmount.fromUnitAndValue(transaction.unit, transaction.amount);
    return Transaction(from: sender, to: receiver, value: etherAmount);
  }

  @override
  void sendEther(Credentials credentials, TransactionDTO transactionDTO) async {
    Credentials credentials = getCredentials(transactionDTO.privateKey);
    Transaction transaction = await prepareTransaction(transactionDTO);
    _ethClient.sendTransaction(credentials, transaction);
  }

  String validatePublicAddress(String address) {
    try {
      EthereumAddress.fromHex(address, enforceEip55: true);
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  // @override
  // Future<List> query(String functionName, List args) {
  //   // TODO: implement query over smart contract
  //   throw UnimplementedError();
  // }
}