import 'dart:async';
import 'dart:io';

import 'package:add_to_wallet/add_to_wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

/// Native event names. Must match AddToWalletEvent.swift and the
/// invokeMethod calls in AddToWalletPlugin.swift.
const _addButtonPressedMethod = 'add_button_pressed';
const _onPassAddedMethod = 'onPassAdded';

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
  final FutureOr<void> Function()?
      onPassAdded; // New callback for successful pass addition

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
    this.onPassAdded,
  }) : super(key: key ?? UniqueKey()) {
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
    _id = Uuid().v4();
    // A single handler per widget, routed by `_id` through AddToWallet so that
    // each button only receives its own events. Do not call
    // setMethodCallHandler on the 'add_to_wallet' channel from here: a channel
    // has exactly one handler, so that would replace AddToWallet's dispatcher
    // and break key based routing for every button.
    AddToWallet().addHandler(_id, (call) {
      switch (call.method) {
        case _addButtonPressedMethod:
          return widget.onPressed?.call();
        case _onPassAddedMethod:
          return widget.onPassAdded?.call();
      }
    });
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
        'onPassAdded':
            widget.onPassAdded != null, // Indicate if the callback is provided
      };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: platformWidget(context),
    );
  }

  Widget platformWidget(BuildContext context) {
    if (!Platform.isIOS) {
      return widget.unsupportedPlatformChild ?? const SizedBox.shrink();
    }

    // This key changes if any of its constituent values change,
    // forcing the UiKitView to be recreated.
    final platformViewKey = ValueKey(
        // Construct a key from all parameters that define the native view.
        // This includes parameters from uiKitCreationParams.
        '${widget.width}-${widget.height}-${widget.borderRadius}-${widget.pkPass?.hashCode ?? 'null_pkPass'}-${widget.issuerData ?? 'null_issuerData'}-${widget.signature ?? 'null_signature'}-${_id}');

    return UiKitView(
      key:
          platformViewKey, // Added key to ensure recreation when parameters change
      viewType: AddToWalletButton.viewType,
      layoutDirection: Directionality.of(context),
      creationParams: uiKitCreationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
