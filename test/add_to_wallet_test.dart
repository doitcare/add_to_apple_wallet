import 'package:add_to_wallet/add_to_wallet.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

// Scope note: these cover AddToWallet's dispatcher, which is what routes a
// native event to the right AddToWalletButton. The button's own registration
// cannot be covered here -- its iOS branch is gated on Platform.isIOS, which
// dart:io does not allow a host test to override, so UiKitView is never built
// off-device. Verifying the button end to end needs a physical device.

/// Delivers a native event on the plugin channel the same way the iOS side
/// does via `_channel.invokeMethod(..., arguments: ["key": _key])`.
Future<void> sendNativeEvent(String method, String key) {
  return TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .handlePlatformMessage(
    'add_to_wallet',
    const StandardMethodCodec()
        .encodeMethodCall(MethodCall(method, {'key': key})),
    (_) {},
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('routes an event to the handler owning that key', () async {
    MethodCall? receivedByA;
    var bCallCount = 0;

    await AddToWallet().addHandler('a', (call) => receivedByA = call);
    await AddToWallet().addHandler('b', (_) => bCallCount++);
    addTearDown(() {
      AddToWallet().removeHandler('a');
      AddToWallet().removeHandler('b');
    });

    await sendNativeEvent('add_button_pressed', 'a');

    expect(receivedByA?.method, 'add_button_pressed');
    expect(bCallCount, 0, reason: 'another key must not receive this event');
  });

  test('passes the method name through so the widget can dispatch on it',
      () async {
    // The button distinguishes onPressed from onPassAdded purely by
    // call.method, so both native event names have to survive routing.
    final methods = <String>[];
    await AddToWallet().addHandler('a', (call) => methods.add(call.method));
    addTearDown(() => AddToWallet().removeHandler('a'));

    await sendNativeEvent('add_button_pressed', 'a');
    await sendNativeEvent('onPassAdded', 'a');

    expect(methods, ['add_button_pressed', 'onPassAdded']);
  });

  test('a removed handler stops receiving events', () async {
    var calls = 0;
    await AddToWallet().addHandler('a', (_) => calls++);

    await sendNativeEvent('add_button_pressed', 'a');
    AddToWallet().removeHandler('a');
    await sendNativeEvent('add_button_pressed', 'a');

    expect(calls, 1);
  });

  test('an event for an unknown key reaches no handler and does not throw',
      () async {
    var calls = 0;
    await AddToWallet().addHandler('a', (_) => calls++);
    addTearDown(() => AddToWallet().removeHandler('a'));

    await expectLater(
        sendNativeEvent('add_button_pressed', 'no-such-key'), completes);

    expect(calls, 0,
        reason: 'an unknown key must not fall through to another handler');
  });
}
