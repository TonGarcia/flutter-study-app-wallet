import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/web3dart.dart';

class DrawnPage extends StatefulWidget {
  const DrawnPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _DrawnPageState createState() => _DrawnPageState();
}

class _DrawnPageState extends State<DrawnPage> {
  late Client httpClient;
  late Web3Client ethClient;
  bool data = false;
  final myAddress = '0x72a686B13e560E633359ad79DD3Af8b697A2a50B';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Vx.gray300,
      body: ZStack([
        VxBox()
            .blue600
            .size(context.screenWidth, context.percentHeight*30)
            .make(),
        VStack([
          (context.percentHeight * 10).heightBox,
          "\$WALLET".text.xl4.white.bold.center.makeCentered().py16(), //x14 = fontsize14, py16=padding16
          (context.percentHeight*5).heightBox,
          VxBox(child: VStack([
            "Balance".text.gray700.xl2.semiBold.makeCentered(),
            10.heightBox,
            data
                ? "\$1".text.bold.xl3.makeCentered()
                : const CircularProgressIndicator().centered()
          ]))
              .p16
              .white
              .size(context.screenWidth, context.percentHeight*18)
              .rounded
              .shadowXs // shadowx1
              .make()
              .p16(),
          30.heightBox,
          HStack([
            FlatButton.icon(
                onPressed: (){},
                color: Colors.blue,
                shape: Vx.roundedSm,
                icon: Icon(
                    Icons.refresh,
                    color: Colors.white
                ),
                label: "Refresh".text.white.make()
            ).h(50), //increate button height,
            FlatButton.icon(
                onPressed: (){},
                color: Colors.green,
                shape: Vx.roundedSm,
                icon: Icon(
                    Icons.call_made_outlined,
                    color: Colors.white
                ),
                label: "Deposit".text.white.make()
            ).h(50), //increate button height,
            FlatButton.icon(
                onPressed: (){},
                color: Colors.red,
                shape: Vx.roundedSm,
                icon: Icon(
                    Icons.call_received_outlined,
                    color: Colors.white
                ),
                label: "Withdraw".text.white.make()
            ).h(50), //increate button height
          ],
            alignment: MainAxisAlignment.spaceAround,
            axisSize: MainAxisSize.max,
          ).p16()
        ])
      ])
    );
  }
}