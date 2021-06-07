part of _internal;

mixin DiscoveryMixin on FlutterBLE {
  Future<void> discoverServices(
      Peripheral peripheral) async {
    await _methodChannel.invokeMethod(
      MethodName.discoverServices,
      <String, dynamic>{
        ArgumentName.deviceIdentifier: peripheral.identifier,
      },
    ).catchError((errorJson) =>
        Future.error(BleError.fromJson(jsonDecode(errorJson.details))));
  }

  Future<List<Characteristic>> discoverCharacteristics(
      Service service) async {
    final jsonString = await _methodChannel.invokeMethod(
      MethodName.discoverCharacteristics,
      <String, dynamic>{
        ArgumentName.deviceIdentifier: service.peripheral.identifier,
        ArgumentName.serviceUuid: service.uuid
      },
    ).catchError((errorJson) =>
        Future.error(BleError.fromJson(jsonDecode(errorJson.details))));

    Map<String, dynamic> jsonObject = jsonDecode(jsonString);
    final jsonCharacteristics = (jsonObject['characteristics'] as List<dynamic>)
        .cast<Map<String, dynamic>>();

    return jsonCharacteristics.map((characteristicJson) {
      return Characteristic.fromJson(characteristicJson, service, _manager);
    }).toList();
  }
  
  Future<void> discoverAllServicesAndCharacteristics(
      Peripheral peripheral, String transactionId) async {
    await _methodChannel.invokeMethod(
      MethodName.discoverAllServicesAndCharacteristics,
      <String, dynamic>{
        ArgumentName.deviceIdentifier: peripheral.identifier,
        ArgumentName.transactionId: transactionId,
      },
    ).catchError((errorJson) =>
        Future.error(BleError.fromJson(jsonDecode(errorJson.details))));
  }

  Future<List<Service>> services(Peripheral peripheral) async {
    String jsonString = await _methodChannel.invokeMethod(
      MethodName.services,
      <String, dynamic>{
        ArgumentName.deviceIdentifier: peripheral.identifier,
      },
    ).catchError((errorJson) =>
        Future.error(BleError.fromJson(jsonDecode(errorJson.details))));

    final decodedJson =
        (jsonDecode(jsonString) as List<dynamic>).cast<Map<String, dynamic>>();

    return decodedJson
        .map((serviceJson) =>
            Service.fromJson(serviceJson, peripheral, _manager))
        .toList();
  }

  Future<List<Characteristic>> characteristics(
      Peripheral peripheral, String serviceUuid) async {
    String jsonString = await _methodChannel.invokeMethod(
      MethodName.characteristics,
      <String, dynamic>{
        ArgumentName.deviceIdentifier: peripheral.identifier,
        ArgumentName.serviceUuid: serviceUuid,
      },
    ).catchError((errorJson) =>
        Future.error(BleError.fromJson(jsonDecode(errorJson.details))));

    Map<String, dynamic> jsonObject = jsonDecode(jsonString);
    final jsonCharacteristics = (jsonObject['characteristics'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    final service = Service.fromJson(jsonObject, peripheral, _manager);

    return jsonCharacteristics.map((characteristicJson) {
      return Characteristic.fromJson(characteristicJson, service, _manager);
    }).toList();
  }

  Future<List<Characteristic>> characteristicsForService(
      Service service) async {
    String jsonString = await _methodChannel.invokeMethod(
      MethodName.characteristicsForService,
      <String, dynamic>{
        ArgumentName.serviceIdentifier: service._id,
      },
    ).catchError((errorJson) =>
        Future.error(BleError.fromJson(jsonDecode(errorJson.details))));

    final jsonList =
        (jsonDecode(jsonString) as List<dynamic>).cast<Map<String, dynamic>>();

    return jsonList.map((characteristicJson) {
      return Characteristic.fromJson(characteristicJson, service, _manager);
    }).toList();
  }

  Future<List<Descriptor>> descriptorsForPeripheral(
    Peripheral peripheral,
    String serviceUuid,
    String characteristicUuid,
  ) async {
    String jsonString = await _methodChannel
        .invokeMethod(MethodName.descriptorsForDevice, <String, dynamic>{
      ArgumentName.deviceIdentifier: peripheral.identifier,
      ArgumentName.serviceUuid: serviceUuid,
      ArgumentName.characteristicUuid: characteristicUuid,
    }).catchError(
      (errorJson) => Future.error(
        BleError.fromJson(jsonDecode(errorJson.details)),
      ),
    );

    Map<String, dynamic> jsonObject = jsonDecode(jsonString);

    final service = Service.fromJson(jsonObject, peripheral, _manager);
    final characteristic =
        Characteristic.fromJson(jsonObject, service, _manager);

    final jsonDescriptors = (jsonObject['descriptors'] as List<dynamic>)
        .cast<Map<String, dynamic>>();

    return jsonDescriptors
        .map((jsonDescriptor) =>
            Descriptor.fromJson(jsonDescriptor, characteristic, _manager))
        .toList();
  }

  Future<List<Descriptor>> descriptorsForService(
    Service service,
    String characteristicUuid,
  ) async {
    String jsonString = await _methodChannel
        .invokeMethod(MethodName.descriptorsForService, <String, dynamic>{
      ArgumentName.serviceIdentifier: service._id,
      ArgumentName.characteristicUuid: characteristicUuid,
    }).catchError(
      (errorJson) => Future.error(
        BleError.fromJson(jsonDecode(errorJson.details)),
      ),
    );

    Map<String, dynamic> jsonObject = jsonDecode(jsonString);

    final characteristic =
        Characteristic.fromJson(jsonObject, service, _manager);

    final jsonDescriptors = (jsonObject['descriptors'] as List<dynamic>)
        .cast<Map<String, dynamic>>();

    return jsonDescriptors
        .map((jsonDescriptor) =>
            Descriptor.fromJson(jsonDescriptor, characteristic, _manager))
        .toList();
  }

  Future<List<Descriptor>> descriptorsForCharacteristic(
    Characteristic characteristic,
  ) async {
    String jsonString = await _methodChannel.invokeMethod(
        MethodName.descriptorsForCharacteristic, <String, dynamic>{
      ArgumentName.characteristicIdentifier: characteristic._id,
    }).catchError(
      (errorJson) => Future.error(
        BleError.fromJson(jsonDecode(errorJson.details)),
      ),
    );

    Map<String, dynamic> json = jsonDecode(jsonString);

    final jsonDescriptors =
        (json['descriptors'] as List<dynamic>).cast<Map<String, dynamic>>();
    return jsonDescriptors
        .map((jsonDescriptor) =>
            Descriptor.fromJson(jsonDescriptor, characteristic, _manager))
        .toList();
  }
}
