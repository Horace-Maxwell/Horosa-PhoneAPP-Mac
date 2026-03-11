import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rive/rive.dart';

class CoinFlip extends StatefulWidget {
  const CoinFlip({super.key, required this.value});

  final double value;

  @override
  State<CoinFlip> createState() => _CoinFlipState();
}

class _CoinFlipState extends State<CoinFlip> {
  StateMachineController? controller;
  Artboard? _artboard;
  SMINumber? _input;

  @override
  void initState() {
    super.initState();
    RiveFile.initialize();
    rootBundle.load('assets/rives/coin.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        controller = StateMachineController.fromArtboard(artboard, 'coin');
        artboard.addController(controller!);
        setState(() {
          _input = controller?.getNumberInput('value');
          _input?.change(widget.value * -1);
          _artboard = artboard;
        });
      },
    );
  }

  @override
  void didUpdateWidget(CoinFlip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(_input != null) {
      setState(() {
        _input?.change(widget.value * -1);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (controller != null) {
      controller!.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140.w,
      height: 140.w,
      child: _artboard != null
      ?  Rive(
        artboard: _artboard!,
      )
      : const SizedBox(),
    );
  }
}
