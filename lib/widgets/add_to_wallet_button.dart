import 'dart:async';
import 'dart:io';

import 'package:add_to_wallet/add_to_wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class AddToWalletButton extends StatefulWidget {
  static const viewType = 'PKAddPassButton';

  final List<int>? pkPass;
  final String? issuerData;
  final String? signature;
  final double width;
  final double height;
  final double borderRadius;
  final Widget? unsupportedPlatformChild;
  final FutureOr<void> Function()? onPressed;

  AddToWalletButton({
    Key? key,
    this.pkPass,
    this.issuerData,
    this.signature,
    required this.width,
    required this.height,
    this.borderRadius = 8,
    this.onPressed,
    this.unsupportedPlatformChild,
  }) : super(key: key) {
    assert(pkPass != null || (issuerData != null && signature != null));
  }

  @override
  _AddToWalletButtonState createState() => _AddToWalletButtonState();
}

class _AddToWalletButtonState extends State<AddToWalletButton> {
  late final String _id;

  @override
  void initState() {
    super.initState();
    _id = const Uuid().v4();
    AddToWallet().addHandler(_id, (_) => widget.onPressed?.call());
  }

  @override
  void dispose() {
    AddToWallet().removeHandler(_id);
    super.dispose();
  }

  Map<String, dynamic> get uiKitCreationParams => {
        'width': widget.width,
        'height': widget.height,
        'borderRadius': widget.borderRadius,
        'pass': widget.pkPass,
        'issuerData': widget.issuerData,
        'signature': widget.signature,
        'key': _id,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: platformWidget(context),
    );
  }

  Widget platformWidget(BuildContext context) {
    if (!Platform.isIOS) {
      return widget.unsupportedPlatformChild ?? const SizedBox.shrink();
    }

    return UiKitView(
      viewType: AddToWalletButton.viewType,
      layoutDirection: Directionality.of(context),
      creationParams: uiKitCreationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
