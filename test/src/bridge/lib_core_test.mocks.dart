// Mocks generated by Mockito 5.0.3 from annotations
// in flutter_ble_lib/example/ios/.symlinks/plugins/flutter_ble_lib/test/src/bridge/lib_core_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;
import 'dart:typed_data' as _i3;

import 'package:flutter_ble_lib/flutter_ble_lib.dart' as _i2;
import 'package:flutter_ble_lib/src/_internal.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: comment_references
// ignore_for_file: unnecessary_parenthesis

class _FakeCharacteristicWithValue extends _i1.Fake
    implements _i2.CharacteristicWithValue {}

class _FakeCharacteristic extends _i1.Fake implements _i2.Characteristic {}

class _FakeDescriptorWithValue extends _i1.Fake
    implements _i2.DescriptorWithValue {}

class _FakeDescriptor extends _i1.Fake implements _i2.Descriptor {}

class _FakePeripheral extends _i1.Fake implements _i2.Peripheral {}

class _FakeUint8List extends _i1.Fake implements _i3.Uint8List {}

/// A class which mocks [Peripheral].
///
/// See the documentation for Mockito's code generation for more information.
class MockPeripheral extends _i1.Mock implements _i2.Peripheral {
  MockPeripheral() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get identifier =>
      (super.noSuchMethod(Invocation.getter(#identifier), returnValue: '')
          as String);
  @override
  set identifier(String? _identifier) =>
      super.noSuchMethod(Invocation.setter(#identifier, _identifier),
          returnValueForMissingStub: null);
  @override
  _i4.Future<void> connect(
          {bool? isAutoConnect = false,
          int? requestMtu = 0,
          bool? refreshGatt = false,
          Duration? timeout}) =>
      (super.noSuchMethod(
          Invocation.method(#connect, [], {
            #isAutoConnect: isAutoConnect,
            #requestMtu: requestMtu,
            #refreshGatt: refreshGatt,
            #timeout: timeout
          }),
          returnValue: Future.value(null),
          returnValueForMissingStub: Future.value()) as _i4.Future<void>);
  @override
  _i4.Stream<_i2.PeripheralConnectionState> observeConnectionState(
          {bool? emitCurrentValue = false,
          bool? completeOnDisconnect = false}) =>
      (super.noSuchMethod(
              Invocation.method(#observeConnectionState, [], {
                #emitCurrentValue: emitCurrentValue,
                #completeOnDisconnect: completeOnDisconnect
              }),
              returnValue: Stream<_i2.PeripheralConnectionState>.empty())
          as _i4.Stream<_i2.PeripheralConnectionState>);
  @override
  _i4.Future<bool> isConnected() =>
      (super.noSuchMethod(Invocation.method(#isConnected, []),
          returnValue: Future.value(false)) as _i4.Future<bool>);
  @override
  _i4.Future<void> disconnectOrCancelConnection() =>
      (super.noSuchMethod(Invocation.method(#disconnectOrCancelConnection, []),
          returnValue: Future.value(null),
          returnValueForMissingStub: Future.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> discoverAllServicesAndCharacteristics(
          {String? transactionId}) =>
      (super.noSuchMethod(
          Invocation.method(#discoverAllServicesAndCharacteristics, [],
              {#transactionId: transactionId}),
          returnValue: Future.value(null),
          returnValueForMissingStub: Future.value()) as _i4.Future<void>);
  @override
  _i4.Future<List<_i2.Service>> services() =>
      (super.noSuchMethod(Invocation.method(#services, []),
              returnValue: Future.value(<_i2.Service>[]))
          as _i4.Future<List<_i2.Service>>);
  @override
  _i4.Future<List<_i2.Characteristic>> characteristics(String? servicedUuid) =>
      (super.noSuchMethod(Invocation.method(#characteristics, [servicedUuid]),
              returnValue: Future.value(<_i2.Characteristic>[]))
          as _i4.Future<List<_i2.Characteristic>>);
  @override
  _i4.Future<int> rssi({String? transactionId}) => (super.noSuchMethod(
      Invocation.method(#rssi, [], {#transactionId: transactionId}),
      returnValue: Future.value(0)) as _i4.Future<int>);
  @override
  _i4.Future<int> requestMtu(int? mtu, {String? transactionId}) =>
      (super.noSuchMethod(
          Invocation.method(
              #requestMtu, [mtu], {#transactionId: transactionId}),
          returnValue: Future.value(0)) as _i4.Future<int>);
  @override
  _i4.Future<_i2.CharacteristicWithValue> readCharacteristic(
          String? serviceUuid, String? characteristicUuid,
          {String? transactionId}) =>
      (super.noSuchMethod(
              Invocation.method(
                  #readCharacteristic,
                  [serviceUuid, characteristicUuid],
                  {#transactionId: transactionId}),
              returnValue: Future.value(_FakeCharacteristicWithValue()))
          as _i4.Future<_i2.CharacteristicWithValue>);
  @override
  _i4.Future<_i2.Characteristic?> writeCharacteristic(String? serviceUuid,
          String? characteristicUuid, _i3.Uint8List? value, bool? withResponse,
          {String? transactionId}) =>
      (super.noSuchMethod(
              Invocation.method(
                  #writeCharacteristic,
                  [serviceUuid, characteristicUuid, value, withResponse],
                  {#transactionId: transactionId}),
              returnValue: Future.value(_FakeCharacteristic()))
          as _i4.Future<_i2.Characteristic?>);
  @override
  _i4.Future<List<_i2.Descriptor>> descriptorsForCharacteristic(
          String? serviceUuid, String? characteristicUuid) =>
      (super.noSuchMethod(
              Invocation.method(#descriptorsForCharacteristic,
                  [serviceUuid, characteristicUuid]),
              returnValue: Future.value(<_i2.Descriptor>[]))
          as _i4.Future<List<_i2.Descriptor>>);
  @override
  _i4.Future<_i2.DescriptorWithValue> readDescriptor(String? serviceUuid,
          String? characteristicUuid, String? descriptorUuid,
          {String? transactionId}) =>
      (super.noSuchMethod(
              Invocation.method(
                  #readDescriptor,
                  [serviceUuid, characteristicUuid, descriptorUuid],
                  {#transactionId: transactionId}),
              returnValue: Future.value(_FakeDescriptorWithValue()))
          as _i4.Future<_i2.DescriptorWithValue>);
  @override
  _i4.Future<_i2.Descriptor> writeDescriptor(
          String? serviceUuid,
          String? characteristicUuid,
          String? descriptorUuid,
          _i3.Uint8List? value,
          {String? transactionId}) =>
      (super.noSuchMethod(
              Invocation.method(
                  #writeDescriptor,
                  [serviceUuid, characteristicUuid, descriptorUuid, value],
                  {#transactionId: transactionId}),
              returnValue: Future.value(_FakeDescriptor()))
          as _i4.Future<_i2.Descriptor>);
  @override
  _i4.Stream<_i2.CharacteristicWithValue> monitorCharacteristic(
          String? serviceUuid, String? characteristicUuid,
          {String? transactionId}) =>
      (super.noSuchMethod(
              Invocation.method(
                  #monitorCharacteristic,
                  [serviceUuid, characteristicUuid],
                  {#transactionId: transactionId}),
              returnValue: Stream<_i2.CharacteristicWithValue>.empty())
          as _i4.Stream<_i2.CharacteristicWithValue>);
  @override
  String toString() =>
      (super.noSuchMethod(Invocation.method(#toString, []), returnValue: '')
          as String);
}

/// A class which mocks [InternalBleManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockInternalBleManager extends _i1.Mock
    implements _i5.InternalBleManager {
  MockInternalBleManager() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<void> createClient(
          {String? restoreStateIdentifier,
          _i2.RestoreStateAction? restoreStateAction}) =>
      (super.noSuchMethod(
          Invocation.method(#createClient, [], {
            #restoreStateIdentifier: restoreStateIdentifier,
            #restoreStateAction: restoreStateAction
          }),
          returnValue: Future.value(null),
          returnValueForMissingStub: Future.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> destroyClient() =>
      (super.noSuchMethod(Invocation.method(#destroyClient, []),
          returnValue: Future.value(null),
          returnValueForMissingStub: Future.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> cancelTransaction(String? transactionId) => (super
      .noSuchMethod(Invocation.method(#cancelTransaction, [transactionId]),
          returnValue: Future.value(null),
          returnValueForMissingStub: Future.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> enableRadio({String? transactionId}) => (super.noSuchMethod(
      Invocation.method(#enableRadio, [], {#transactionId: transactionId}),
      returnValue: Future.value(null),
      returnValueForMissingStub: Future.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> disableRadio({String? transactionId}) => (super.noSuchMethod(
      Invocation.method(#disableRadio, [], {#transactionId: transactionId}),
      returnValue: Future.value(null),
      returnValueForMissingStub: Future.value()) as _i4.Future<void>);
  @override
  _i4.Future<_i2.BluetoothState> bluetoothState() =>
      (super.noSuchMethod(Invocation.method(#bluetoothState, []),
              returnValue: Future.value(_i2.BluetoothState.UNKNOWN))
          as _i4.Future<_i2.BluetoothState>);
  @override
  _i4.Stream<_i2.BluetoothState> observeBluetoothState(
          {bool? emitCurrentValue = true}) =>
      (super.noSuchMethod(
              Invocation.method(#observeBluetoothState, [],
                  {#emitCurrentValue: emitCurrentValue}),
              returnValue: Stream<_i2.BluetoothState>.empty())
          as _i4.Stream<_i2.BluetoothState>);
  @override
  _i4.Stream<_i2.ScanResult> startPeripheralScan(
          {int? scanMode = 0,
          int? callbackType = 1,
          List<String>? uuids = const [],
          bool? allowDuplicates = false}) =>
      (super.noSuchMethod(
              Invocation.method(#startPeripheralScan, [], {
                #scanMode: scanMode,
                #callbackType: callbackType,
                #uuids: uuids,
                #allowDuplicates: allowDuplicates
              }),
              returnValue: Stream<_i2.ScanResult>.empty())
          as _i4.Stream<_i2.ScanResult>);
  @override
  _i4.Future<void> stopPeripheralScan() =>
      (super.noSuchMethod(Invocation.method(#stopPeripheralScan, []),
          returnValue: Future.value(null),
          returnValueForMissingStub: Future.value()) as _i4.Future<void>);
  @override
  _i2.Peripheral createUnsafePeripheral(String? peripheralId, {String? name}) =>
      (super.noSuchMethod(
          Invocation.method(
              #createUnsafePeripheral, [peripheralId], {#name: name}),
          returnValue: _FakePeripheral()) as _i2.Peripheral);
  @override
  _i4.Future<void> connectToPeripheral(String? identifier,
          {bool? isAutoConnect,
          int? requestMtu,
          bool? refreshGatt,
          Duration? timeout}) =>
      (super.noSuchMethod(
          Invocation.method(#connectToPeripheral, [
            identifier
          ], {
            #isAutoConnect: isAutoConnect,
            #requestMtu: requestMtu,
            #refreshGatt: refreshGatt,
            #timeout: timeout
          }),
          returnValue: Future.value(null),
          returnValueForMissingStub: Future.value()) as _i4.Future<void>);
  @override
  _i4.Stream<_i2.PeripheralConnectionState> observePeripheralConnectionState(
          String? peripheralIdentifier,
          bool? emitCurrentValue,
          bool? completeOnDisconnect) =>
      (super.noSuchMethod(
              Invocation.method(#observePeripheralConnectionState, [
                peripheralIdentifier,
                emitCurrentValue,
                completeOnDisconnect
              ]),
              returnValue: Stream<_i2.PeripheralConnectionState>.empty())
          as _i4.Stream<_i2.PeripheralConnectionState>);
  @override
  _i4.Future<void> disconnectOrCancelPeripheralConnection(
          String? peripheralIdentifier) =>
      (super.noSuchMethod(
          Invocation.method(
              #disconnectOrCancelPeripheralConnection, [peripheralIdentifier]),
          returnValue: Future.value(null),
          returnValueForMissingStub: Future.value()) as _i4.Future<void>);
  @override
  _i4.Future<bool> isPeripheralConnected(String? peripheralIdentifier) =>
      (super.noSuchMethod(
          Invocation.method(#isPeripheralConnected, [peripheralIdentifier]),
          returnValue: Future.value(false)) as _i4.Future<bool>);
  @override
  _i4.Future<_i2.LogLevel> logLevel() =>
      (super.noSuchMethod(Invocation.method(#logLevel, []),
              returnValue: Future.value(_i2.LogLevel.none))
          as _i4.Future<_i2.LogLevel>);
  @override
  _i4.Future<void> setLogLevel(_i2.LogLevel? logLevel) =>
      (super.noSuchMethod(Invocation.method(#setLogLevel, [logLevel]),
          returnValue: Future.value(null),
          returnValueForMissingStub: Future.value()) as _i4.Future<void>);
  @override
  _i4.Future<List<_i2.Characteristic>> characteristics(
          _i2.Peripheral? peripheral, String? serviceUuid) =>
      (super.noSuchMethod(
              Invocation.method(#characteristics, [peripheral, serviceUuid]),
              returnValue: Future.value(<_i2.Characteristic>[]))
          as _i4.Future<List<_i2.Characteristic>>);
  @override
  _i4.Future<List<_i2.Service>> services(_i2.Peripheral? peripheral) =>
      (super.noSuchMethod(Invocation.method(#services, [peripheral]),
              returnValue: Future.value(<_i2.Service>[]))
          as _i4.Future<List<_i2.Service>>);
  @override
  _i4.Future<List<_i2.Descriptor>> descriptorsForPeripheral(
          _i2.Peripheral? peripheral,
          String? serviceUuid,
          String? characteristicUuid) =>
      (super.noSuchMethod(
              Invocation.method(#descriptorsForPeripheral,
                  [peripheral, serviceUuid, characteristicUuid]),
              returnValue: Future.value(<_i2.Descriptor>[]))
          as _i4.Future<List<_i2.Descriptor>>);
  @override
  _i4.Future<List<_i2.Descriptor>> descriptorsForService(
          _i2.Service? service, String? characteristicUuid) =>
      (super.noSuchMethod(
              Invocation.method(
                  #descriptorsForService, [service, characteristicUuid]),
              returnValue: Future.value(<_i2.Descriptor>[]))
          as _i4.Future<List<_i2.Descriptor>>);
  @override
  _i4.Future<List<_i2.Descriptor>> descriptorsForCharacteristic(
          _i2.Characteristic? characteristic) =>
      (super.noSuchMethod(
          Invocation.method(#descriptorsForCharacteristic, [characteristic]),
          returnValue:
              Future.value(<_i2.Descriptor>[])) as _i4
          .Future<List<_i2.Descriptor>>);
  @override
  _i4.Future<void> discoverAllServicesAndCharacteristics(
          _i2.Peripheral? peripheral, String? transactionId) =>
      (super.noSuchMethod(
          Invocation.method(#discoverAllServicesAndCharacteristics,
              [peripheral, transactionId]),
          returnValue: Future.value(null),
          returnValueForMissingStub: Future.value()) as _i4.Future<void>);
  @override
  _i4.Future<List<_i2.Characteristic>> characteristicsForService(
          _i2.Service? service) =>
      (super.noSuchMethod(
              Invocation.method(#characteristicsForService, [service]),
              returnValue: Future.value(<_i2.Characteristic>[]))
          as _i4.Future<List<_i2.Characteristic>>);
  @override
  _i4.Future<int> rssi(_i2.Peripheral? peripheral, String? transactionId) =>
      (super.noSuchMethod(Invocation.method(#rssi, [peripheral, transactionId]),
          returnValue: Future.value(0)) as _i4.Future<int>);
  @override
  _i4.Future<int> requestMtu(
          _i2.Peripheral? peripheral, int? mtu, String? transactionId) =>
      (super.noSuchMethod(
          Invocation.method(#requestMtu, [peripheral, mtu, transactionId]),
          returnValue: Future.value(0)) as _i4.Future<int>);
  @override
  _i4.Future<List<_i2.Peripheral>> knownPeripherals(
          List<String>? peripheralIdentifiers) =>
      (super.noSuchMethod(
              Invocation.method(#knownPeripherals, [peripheralIdentifiers]),
              returnValue: Future.value(<_i2.Peripheral>[]))
          as _i4.Future<List<_i2.Peripheral>>);
  @override
  _i4.Future<List<_i2.Peripheral>> connectedPeripherals(
          List<String>? serviceUuids) =>
      (super.noSuchMethod(
              Invocation.method(#connectedPeripherals, [serviceUuids]),
              returnValue: Future.value(<_i2.Peripheral>[]))
          as _i4.Future<List<_i2.Peripheral>>);
  @override
  _i4.Future<_i3.Uint8List> readCharacteristicForIdentifier(
          _i2.Peripheral? peripheral,
          _i5.InternalCharacteristic? characteristic,
          String? transactionId) =>
      (super.noSuchMethod(
              Invocation.method(#readCharacteristicForIdentifier,
                  [peripheral, characteristic, transactionId]),
              returnValue: Future.value(_FakeUint8List()))
          as _i4.Future<_i3.Uint8List>);
  @override
  _i4.Future<_i2.CharacteristicWithValue> readCharacteristicForDevice(
          _i2.Peripheral? peripheral,
          String? serviceUuid,
          String? characteristicUuid,
          String? transactionId) =>
      (super.noSuchMethod(
              Invocation.method(#readCharacteristicForDevice,
                  [peripheral, serviceUuid, characteristicUuid, transactionId]),
              returnValue: Future.value(_FakeCharacteristicWithValue()))
          as _i4.Future<_i2.CharacteristicWithValue>);
  @override
  _i4.Future<_i2.CharacteristicWithValue> readCharacteristicForService(
          _i2.Peripheral? peripheral,
          _i5.InternalService? service,
          String? characteristicUuid,
          String? transactionId) =>
      (super.noSuchMethod(
              Invocation.method(#readCharacteristicForService,
                  [peripheral, service, characteristicUuid, transactionId]),
              returnValue: Future.value(_FakeCharacteristicWithValue()))
          as _i4.Future<_i2.CharacteristicWithValue>);
  @override
  _i4.Future<_i2.Characteristic?> writeCharacteristicForIdentifier(
          _i2.Peripheral? peripheral,
          _i5.InternalCharacteristic? characteristic,
          _i3.Uint8List? value,
          bool? withResponse,
          String? transactionId) =>
      (super.noSuchMethod(
              Invocation.method(#writeCharacteristicForIdentifier, [
                peripheral,
                characteristic,
                value,
                withResponse,
                transactionId
              ]),
              returnValue: Future.value(_FakeCharacteristic()))
          as _i4.Future<_i2.Characteristic?>);
  @override
  _i4.Future<_i2.Characteristic?> writeCharacteristicForDevice(
          _i2.Peripheral? peripheral,
          String? serviceUuid,
          String? characteristicUuid,
          _i3.Uint8List? value,
          bool? withResponse,
          String? transactionId) =>
      (super.noSuchMethod(
              Invocation.method(#writeCharacteristicForDevice, [
                peripheral,
                serviceUuid,
                characteristicUuid,
                value,
                withResponse,
                transactionId
              ]),
              returnValue: Future.value(_FakeCharacteristic()))
          as _i4.Future<_i2.Characteristic?>);
  @override
  _i4.Future<_i2.Characteristic?> writeCharacteristicForService(
          _i2.Peripheral? peripheral,
          _i5.InternalService? service,
          String? characteristicUuid,
          _i3.Uint8List? value,
          bool? withResponse,
          String? transactionId) =>
      (super.noSuchMethod(
              Invocation.method(#writeCharacteristicForService, [
                peripheral,
                service,
                characteristicUuid,
                value,
                withResponse,
                transactionId
              ]),
              returnValue: Future.value(_FakeCharacteristic()))
          as _i4.Future<_i2.Characteristic?>);
  @override
  _i4.Stream<_i2.CharacteristicWithValue> monitorCharacteristicForDevice(
          _i2.Peripheral? peripheral,
          String? serviceUuid,
          String? characteristicUuid,
          String? transactionId) =>
      (super.noSuchMethod(
              Invocation.method(#monitorCharacteristicForDevice,
                  [peripheral, serviceUuid, characteristicUuid, transactionId]),
              returnValue: Stream<_i2.CharacteristicWithValue>.empty())
          as _i4.Stream<_i2.CharacteristicWithValue>);
  @override
  _i4.Stream<_i2.CharacteristicWithValue> monitorCharacteristicForService(
          _i2.Peripheral? peripheral,
          _i5.InternalService? service,
          String? characteristicUuid,
          String? transactionId) =>
      (super.noSuchMethod(
              Invocation.method(#monitorCharacteristicForService,
                  [peripheral, service, characteristicUuid, transactionId]),
              returnValue: Stream<_i2.CharacteristicWithValue>.empty())
          as _i4.Stream<_i2.CharacteristicWithValue>);
  @override
  _i4.Stream<_i3.Uint8List> monitorCharacteristicForIdentifier(
          _i2.Peripheral? peripheral,
          _i5.InternalCharacteristic? characteristic,
          String? transactionId) =>
      (super.noSuchMethod(
              Invocation.method(#monitorCharacteristicForIdentifier,
                  [peripheral, characteristic, transactionId]),
              returnValue: Stream<_i3.Uint8List>.empty())
          as _i4.Stream<_i3.Uint8List>);
  @override
  _i4.Future<void> writeDescriptorForIdentifier(_i2.Descriptor? descriptor,
          _i3.Uint8List? value, String? transactionId) =>
      (super.noSuchMethod(
          Invocation.method(#writeDescriptorForIdentifier,
              [descriptor, value, transactionId]),
          returnValue: Future.value(null),
          returnValueForMissingStub: Future.value()) as _i4.Future<void>);
  @override
  _i4.Future<_i2.Descriptor> writeDescriptorForCharacteristic(
          _i2.Characteristic? characteristic,
          String? descriptorUuid,
          _i3.Uint8List? value,
          String? transactionId) =>
      (super.noSuchMethod(
              Invocation.method(#writeDescriptorForCharacteristic,
                  [characteristic, descriptorUuid, value, transactionId]),
              returnValue: Future.value(_FakeDescriptor()))
          as _i4.Future<_i2.Descriptor>);
  @override
  _i4.Future<_i2.Descriptor> writeDescriptorForService(
          _i2.Service? service,
          String? characteristicUuid,
          String? descriptorUuid,
          _i3.Uint8List? value,
          String? transactionId) =>
      (super.noSuchMethod(
              Invocation.method(#writeDescriptorForService, [
                service,
                characteristicUuid,
                descriptorUuid,
                value,
                transactionId
              ]),
              returnValue: Future.value(_FakeDescriptor()))
          as _i4.Future<_i2.Descriptor>);
  @override
  _i4.Future<_i2.Descriptor> writeDescriptorForPeripheral(
          _i2.Peripheral? peripheral,
          String? serviceUuid,
          String? characteristicUuid,
          String? descriptorUuid,
          _i3.Uint8List? value,
          String? transactionId) =>
      (super.noSuchMethod(
              Invocation.method(#writeDescriptorForPeripheral, [
                peripheral,
                serviceUuid,
                characteristicUuid,
                descriptorUuid,
                value,
                transactionId
              ]),
              returnValue: Future.value(_FakeDescriptor()))
          as _i4.Future<_i2.Descriptor>);
  @override
  _i4.Future<_i3.Uint8List> readDescriptorForIdentifier(
          _i2.Descriptor? descriptor, String? transactionId) =>
      (super.noSuchMethod(
              Invocation.method(
                  #readDescriptorForIdentifier, [descriptor, transactionId]),
              returnValue: Future.value(_FakeUint8List()))
          as _i4.Future<_i3.Uint8List>);
  @override
  _i4.Future<_i2.DescriptorWithValue> readDescriptorForCharacteristic(
          _i2.Characteristic? characteristic,
          String? descriptorUuid,
          String? transactionId) =>
      (super.noSuchMethod(
              Invocation.method(#readDescriptorForCharacteristic,
                  [characteristic, descriptorUuid, transactionId]),
              returnValue: Future.value(_FakeDescriptorWithValue()))
          as _i4.Future<_i2.DescriptorWithValue>);
  @override
  _i4.Future<_i2.DescriptorWithValue> readDescriptorForService(
          _i2.Service? service,
          String? characteristicUuid,
          String? descriptorUuid,
          String? transactionId) =>
      (super.noSuchMethod(
              Invocation.method(#readDescriptorForService,
                  [service, characteristicUuid, descriptorUuid, transactionId]),
              returnValue: Future.value(_FakeDescriptorWithValue()))
          as _i4.Future<_i2.DescriptorWithValue>);
  @override
  _i4.Future<_i2.DescriptorWithValue> readDescriptorForPeripheral(
          _i2.Peripheral? peripheral,
          String? serviceUuid,
          String? characteristicUuid,
          String? descriptorUuid,
          String? transactionId) =>
      (super.noSuchMethod(
              Invocation.method(#readDescriptorForPeripheral, [
                peripheral,
                serviceUuid,
                characteristicUuid,
                descriptorUuid,
                transactionId
              ]),
              returnValue: Future.value(_FakeDescriptorWithValue()))
          as _i4.Future<_i2.DescriptorWithValue>);
}
