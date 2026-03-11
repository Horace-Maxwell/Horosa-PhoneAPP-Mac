import 'package:rive/rive.dart';

class HRive {
  final String src, artboard, stateMachine;
  late SMIBool? status;

  HRive({ required this.src, required this.artboard, required this.stateMachine, this.status });

  set setState(SMIBool state) {
    status = state;
  }
}