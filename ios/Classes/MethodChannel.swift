//
//  Method.swift
//  flutter_ble_lib
//
//  Created by Oliver Kocsis on 13/05/2021.
//

import Foundation

enum SignatureError : LocalizedError {
  
  var failureReason: String? {
    switch self {
    case .missingArgsKey(let key, let dict, let id):
      return
        """
        Missing argument key: \(key)
        in dict: \(String(describing: dict)) for method \(id)
        """
    case .invalidValue(let key, let value,
                       let dict, let id,
                       let expected):
      return
        """
        Invalid value: \(value) for key: \(key)
        in dict: \(dict) for method: \(id).
        Expected value type: \(expected) and got \(type(of: value))
        """
    }
  }
  typealias ArgumentKey = Method.DefaultChannel.ArgumentKey
  case missingArgsKey(ArgumentKey,
                      inDict: Dictionary<ArgumentKey, Any>?,
                      id: String)
  case invalidValue(forKey: ArgumentKey, value: Any,
                    inDict: Dictionary<ArgumentKey, Any>, id: String,
                    expected: Any.Type)
}

protocol ArgumentKeyEnum : Hashable, RawRepresentable where RawValue == String {}

protocol SignatureEnum {
  associatedtype ArgumentKeyEnumT: ArgumentKeyEnum
  static func validate(args: [String : Any]?) -> [ArgumentKeyEnumT : Any]?
  init?(_ id: String, args: [ArgumentKeyEnumT : Any]?) throws
}

extension SignatureEnum {
  static func validate(args: [String : Any]?) -> [ArgumentKeyEnumT : Any]? {
    guard let args = args else {
      return nil
    }
    return Dictionary(
      uniqueKeysWithValues: args.compactMap { (key: String, value: Any) in
        guard let argKey = ArgumentKeyEnumT(rawValue: key) else {
          return nil
        }
        return (argKey, value)
      }
    )
  }

}

protocol MethodChannel {
  associatedtype SignatureEnumT: SignatureEnum
  static var name: String { get }
}

protocol CallHandler {
  associatedtype SignatureEnumT: SignatureEnum
  func handle(call: Method.Call<SignatureEnumT>)
}

struct Method {
  class Call<SignatureEnumT> where SignatureEnumT : SignatureEnum {
    let signature: SignatureEnumT
    private var isResulted = false
    private let onResult: FlutterResult
    
    init?(
      _ id: String,
      args: Dictionary<String, Any>?,
      onResult result: @escaping FlutterResult
    ) {
      do {
        guard
          let sig = try SignatureEnumT(
            id,
            args: SignatureEnumT.validate(args: args)
          )
        else {
          result(FlutterMethodNotImplemented)
          return nil
        }
        signature = sig
        onResult = result
      } catch {
        result(FlutterError(bleError: BleError(withError: error)))
        return nil
      }
    }
    
    private func _result(
      _ objectOrError: Result<Any?, Error>
    ) {
      guard
        isResulted == false
      else {
        return
      }
      switch objectOrError {
      case .success(let objectOrError):
        onResult(objectOrError)
      case .failure(let error as BleError):
        onResult(FlutterError(bleError: error))
      case .failure(let error):
        onResult(FlutterError(bleError: BleError(withError: error)))
      }
      isResulted = true
    }
    func result<AnyT: Any, ErrorT: Error>(
      any anyOrError: Result<AnyT, ErrorT>
    ) {
      switch anyOrError {
      case .success(let any):
        _result(.success(any))
      case .failure(let error):
        _result(.failure(error))
      }
    }
    func result<ResponseT : Any>(any: ResponseT) {
      result(any: Result<ResponseT,Error>.success(any))
    }
    func result<ErrorT: Error>(
      _ unitOrError: Result<(), ErrorT>
    ) {
      switch unitOrError {
      case .success:
        _result(.success(nil))
      case .failure(let error):
        _result(.failure(error))
      }
    }
    func result() {
      _result(.success(nil))
    }
    
    func result<ResponseT: Encodable, ErrorT: Error>(
      encodable encodableOrError: Result<ResponseT, ErrorT>
    ) {
      switch encodableOrError {
      case .success(let encodable):
        do {
          let data = try JSONEncoder().encode(encodable)
          let jsonStr = String(data: data, encoding: .utf8)
          _result(.success(jsonStr))
        } catch {
          _result(.failure(error))
        }
      case .failure(let error):
        _result(.failure(error))
      }
    }
    func result<ResponseT : Encodable>(encodable: ResponseT) {
      result(encodable: Result<ResponseT,Error>.success(encodable))
    }
    func result<ErrorT: Error>(_ value: Result<Bool,ErrorT>)  {
      result(any: value)
    }
    func result(_ value: Bool)  {
      result(Result<Bool,Error>.success(value))
    }
    func result<ErrorT: Error>(_ value: Result<Int,ErrorT>)  {
      result(any: value)
    }
    func result(_ value: Int)  {
      result(Result<Int,Error>.success(value))
    }
    func result<ErrorT: Error>(_ value: Result<String, ErrorT>)  {
      result(any: value)
    }
    func result(_ value: String)  {
      result(Result<String,Error>.success(value))
    }
    
  }
  struct DefaultChannel : MethodChannel {
    static let name = "flutter_ble_lib"
    typealias SignatureEnumT = Signature
    
    enum ArgumentKey : String, ArgumentKeyEnum {
      case restoreStateIdentifier = "restoreStateIdentifier"
      case scanMode = "scanMode"
      case allowDuplicates = "allowDuplicates"
      case callbackType = "callbackType"
      case uuids = "uuids"
      case transactionId = "transactionId"
      case deviceUuid = "deviceIdentifier"
      case isAutoConnect = "isAutoConnect"
      case requestMtu = "requestMtu"
      case refreshGatt = "refreshGatt"
      case timeoutMillis = "timeout"
      case emitCurrentValue = "emitCurrentValue"
      case logLevel = "logLevel"
      case serviceUuid = "serviceUuid"
      case serviceNumericId = "serviceId"
      case showPowerAlertOnIOS = "showPowerAlertOnIOS"
      case characteristicUuid = "characteristicUuid"
      case characteristicNumericId = "characteristicIdentifier"
      case value = "value"
      case withResponse = "withResponse"
      case descriptorUuid = "descriptorUuid"
      case descriptorNumericId = "descriptorIdentifier"
      case mtu = "mtu"
      case deviceUuids = "deviceIdentifiers"
    }
    
    enum Signature : SignatureEnum {
      typealias ArgumentKeyEnumT = ArgumentKey
      
      struct ArgsHelper {
        let callId: String
        let args: [ArgumentKey : Any]?
        func requiredValueFor<ArgT>(
          _ key: ArgumentKey,
          type: ArgT.Type
        ) throws -> ArgT {
          guard
            let value = args?[key],
            let args = args
          else {
            throw PluginError.signature(
              .missingArgsKey(
                key,
                inDict: args,
                id: callId
              )
            )
          }
          guard
            let argument = value as? ArgT
          else {
            throw PluginError.signature(
              .invalidValue(
                forKey: key,
                value: value,
                inDict: args,
                id: callId,
                expected: type
              )
            )
          }
          return argument
        }
      }
      
      init?(_ id: String, args: [ArgumentKey : Any]?) throws {
        let argsHelper = ArgsHelper(callId: id, args: args)
        switch id {
        case "isClientCreated":
          self = .isClientCreated
        case "createClient":
          let restoreId = args?[.restoreStateIdentifier] as? String
          let showPowerAlert = args?[.showPowerAlertOnIOS] as? Bool
          self = .createClient(
            restoreId: restoreId,
            showPowerAlert: showPowerAlert
          )
        case "destroyClient":
          self = .destroyClient
        case "cancelTransaction":
          let transactionId = args?[.transactionId]
          self = .cancelTransaction(transactionId: transactionId)
        case "getState":
          self = .getState
        case "enableRadio":
          self = .enableRadio
        case "disableRadio":
          self = .disableRadio
        case "startDeviceScan":
          let uuids = args?[.uuids] as? [String]
          let allowDuplicates = args?[.allowDuplicates] as? Bool
          self = .startDeviceScan(
            uuids: uuids,
            allowDuplicates: allowDuplicates
          )
        case "stopDeviceScan":
          self = .stopDeviceScan
        case "connectToDevice":
          let deviceId =
            try argsHelper.requiredValueFor(.deviceUuid,
                                            type: String.self)
          let timoutMillis = args?[.timeoutMillis] as? Int
          self = .connectToDevice(
            deviceIdentifier: deviceId,
            timoutMillis: timoutMillis
          )
        case "observeConnectionState":
          let deviceId =
            try argsHelper.requiredValueFor(.deviceUuid,
                                            type: String.self)
          let emitCurrentValue = args?[.emitCurrentValue] as? Bool ?? false
          self = .observeConnectionState(
            deviceIdentifier: deviceId,
            emitCurrentValue: emitCurrentValue
          )
        case "cancelConnection":
          let deviceId =
            try argsHelper.requiredValueFor(.deviceUuid,
                                            type: String.self)
          self = .cancelConnection(deviceIdentifier: deviceId)
        case "discoverAllServicesAndCharacteristics":
          let deviceId =
            try argsHelper.requiredValueFor(.deviceUuid,
                                            type: String.self)
          let transactionId = args?[.transactionId] as? String
          self = .discoverAllServicesAndCharacteristics(
            deviceIdentifier: deviceId,
            transactionId: transactionId
          )
        case "services":
          let deviceId =
            try argsHelper.requiredValueFor(.deviceUuid,
                                            type: String.self)
          self = .services(deviceIdentifier: deviceId)
        case "characteristics":
          let deviceId =
            try argsHelper.requiredValueFor(.deviceUuid,
                                            type: String.self)
          let serviceUUID =
            try argsHelper.requiredValueFor(.serviceUuid,
                                            type: String.self)

          self = .characteristics(
            deviceIdentifier: deviceId,
            serviceUUID: serviceUUID
          )
        case "characteristicsForService":
          let serviceNumericId =
            try argsHelper.requiredValueFor(.serviceNumericId,
                                            type: Int.self)
          self = .characteristicsForService(serviceNumericId: serviceNumericId)
        case "descriptorsForDevice":
          let deviceId =
            try argsHelper.requiredValueFor(.deviceUuid,
                                            type: String.self)
          let serviceUUID =
            try argsHelper.requiredValueFor(.serviceUuid,
                                            type: String.self)
          let characteristicUUID =
            try argsHelper.requiredValueFor(.characteristicUuid,
                                            type: String.self)
          self = .descriptorsForDevice(
            deviceIdentifier: deviceId,
            serviceUUID: serviceUUID,
            characteristicUUID: characteristicUUID
          )
        case "descriptorsForService":
          let serviceNumericId =
            try argsHelper.requiredValueFor(.serviceNumericId,
                                            type: Int.self)
          let characteristicUUID =
            try argsHelper.requiredValueFor(.characteristicUuid,
                                            type: String.self)

          self = .descriptorsForService(
            serviceNumericId: serviceNumericId,
            characteristicUUID: characteristicUUID
          )
        case "descriptorsForCharacteristic":
          let characteristicNumericId =
            try argsHelper.requiredValueFor(.characteristicNumericId,
                                            type: Int.self)
          self = .descriptorsForCharacteristic(
            characteristicNumericId: characteristicNumericId
          )
        case "logLevel":
          self = .logLevel
        case "setLogLevel":
          let logLevel =
            try argsHelper.requiredValueFor(.logLevel,
                                            type: String.self)
          self = .setLogLevel(logLevel)
        case "rssi":
          let deviceId =
            try argsHelper.requiredValueFor(.deviceUuid,
                                            type: String.self)
          let transactionId = args?[.transactionId] as? String
          self = .rssi(
            deviceIdentifier: deviceId,
            transactionId: transactionId
          )
        case "requestMtu":
          let deviceId =
            try argsHelper.requiredValueFor(.deviceUuid,
                                            type: String.self)
          let mtu =
            try argsHelper.requiredValueFor(.mtu,
                                            type: Int.self)
          let transactionId = args?[.transactionId] as? String
          self = .requestMtu(
            deviceIdentifier: deviceId,
            mtu: mtu,
            transactionId: transactionId
          )
        case "getConnectedDevices":
          let serviceUUIDs =
            try argsHelper.requiredValueFor(.deviceUuids,
                                            type: [String].self)
          self = .getConnectedDevices(serviceUUIDs: serviceUUIDs)
        case "getKnownDevices":
          let deviceIdentifiers =
            try argsHelper.requiredValueFor(.uuids,
                                            type: [String].self)
          self = .getKnownDevices(deviceIdentifiers: deviceIdentifiers)
        case "readCharacteristicForIdentifier":
          let characteristicNumericId =
            try argsHelper.requiredValueFor(.characteristicNumericId,
                                            type: Int.self)
            
          let transactionId = args?[.transactionId] as? String
          self = .readCharacteristicForIdentifier(
            characteristicNumericId: characteristicNumericId,
            transactionId: transactionId
          )
        case "readCharacteristicForDevice":
          let deviceId =
            try argsHelper.requiredValueFor(.deviceUuid,
                                            type: String.self)
          let serviceUUID =
            try argsHelper.requiredValueFor(.serviceUuid,
                                            type: String.self)
          let characteristicUUID =
            try argsHelper.requiredValueFor(.characteristicUuid,
                                            type: String.self)
          let transactionId = args?[.transactionId] as? String
          self = .readCharacteristicForDevice(
            deviceIdentifier: deviceId,
            serviceUUID: serviceUUID,
            characteristicUUID: characteristicUUID,
            transactionId: transactionId
          )
        case "readCharacteristicForService":
          let serviceNumericId =
            try argsHelper.requiredValueFor(.serviceNumericId,
                                            type: Int.self)
          let characteristicUUID =
            try argsHelper.requiredValueFor(.characteristicUuid,
                                            type: String.self)
          let transactionId = args?[.transactionId] as? String
          self = .readCharacteristicForService(
            serviceNumericId: serviceNumericId,
            characteristicUUID: characteristicUUID,
            transactionId: transactionId
          )
        case "writeCharacteristicForIdentifier":
          let characteristicNumericId =
            try argsHelper.requiredValueFor(.characteristicNumericId,
                                            type: Int.self)
          let value =
            try argsHelper.requiredValueFor(.value,
                                            type: FlutterStandardTypedData.self)
          let withResponse =
            try argsHelper.requiredValueFor(.withResponse,
                                            type: Bool.self)
          let transactionId = args?[.transactionId] as? String
          self = .writeCharacteristicForIdentifier(
            characteristicNumericId: characteristicNumericId,
            value: value,
            withResponse: withResponse,
            transactionId: transactionId
          )
        case "writeCharacteristicForDevice":
          let deviceId =
            try argsHelper.requiredValueFor(.deviceUuid,
                                            type: String.self)
          let serviceUUID =
            try argsHelper.requiredValueFor(.serviceUuid,
                                            type: String.self)
          let characteristicUUID =
            try argsHelper.requiredValueFor(.characteristicUuid,
                                            type: String.self)
          let value =
            try argsHelper.requiredValueFor(.value,
                                            type: FlutterStandardTypedData.self)
          let withResponse =
            try argsHelper.requiredValueFor(.withResponse,
                                            type: Bool.self)
          let transactionId = args?[.transactionId] as? String
          self = .writeCharacteristicForDevice(
            deviceIdentifier: deviceId,
            serviceUUID: serviceUUID,
            characteristicUUID: characteristicUUID,
            value: value,
            withResponse: withResponse,
            transactionId: transactionId
          )
        case "writeCharacteristicForService":
          let serviceNumericId =
            try argsHelper.requiredValueFor(.serviceNumericId,
                                            type: Int.self)
          let characteristicUUID =
            try argsHelper.requiredValueFor(.characteristicUuid,
                                            type: String.self)
          let value =
            try argsHelper.requiredValueFor(.value,
                                            type: FlutterStandardTypedData.self)
          let withResponse =
            try argsHelper.requiredValueFor(.withResponse,
                                            type: Bool.self)
          let transactionId = args?[.transactionId] as? String
          self = .writeCharacteristicForService(
            serviceNumericId: serviceNumericId,
            characteristicUUID: characteristicUUID,
            value: value,
            withResponse: withResponse,
            transactionId: transactionId
          )
        case "monitorCharacteristicForIdentifier":
          let characteristicNumericId =
            try argsHelper.requiredValueFor(.characteristicNumericId,
                                            type: Int.self)
            
          let transactionId = args?[.transactionId] as? String
          self = .monitorCharacteristicForIdentifier(
            characteristicNumericId: characteristicNumericId,
            transactionId: transactionId
          )
        case "monitorCharacteristicForDevice":
          let deviceId =
            try argsHelper.requiredValueFor(.deviceUuid,
                                            type: String.self)
          let serviceUUID =
            try argsHelper.requiredValueFor(.serviceUuid,
                                            type: String.self)
          let characteristicUUID =
            try argsHelper.requiredValueFor(.characteristicUuid,
                                            type: String.self)
          let transactionId = args?[.transactionId] as? String
          self = .monitorCharacteristicForDevice(
            deviceIdentifier: deviceId,
            serviceUUID: serviceUUID,
            characteristicUUID: characteristicUUID,
            transactionId: transactionId
          )
        case "monitorCharacteristicForService":
          let serviceNumericId =
            try argsHelper.requiredValueFor(.serviceNumericId,
                                            type: Int.self)
          let characteristicUUID =
            try argsHelper.requiredValueFor(.characteristicUuid,
                                            type: String.self)
          let transactionId = args?[.transactionId] as? String
          self = .monitorCharacteristicForService(
            serviceNumericId: serviceNumericId,
            characteristicUUID: characteristicUUID,
            transactionId: transactionId
          )
        case "readDescriptorForIdentifier":
          let descriptorNumericId =
            try argsHelper.requiredValueFor(.descriptorNumericId,
                                            type: Int.self)
          let transactionId = args?[.transactionId] as? String
          self = .readDescriptorForIdentifier(
            descriptorNumericId: descriptorNumericId,
            transactionId: transactionId
          )
        case "readDescriptorForCharacteristic":
          let characteristicNumericId =
            try argsHelper.requiredValueFor(.characteristicNumericId,
                                            type: Int.self)
          let descriptorUUID =
            try argsHelper.requiredValueFor(.descriptorUuid,
                                            type: String.self)
          let transactionId = args?[.transactionId] as? String
          self = .readDescriptorForCharacteristic(
            characteristicNumericId: characteristicNumericId,
            descriptorUUID: descriptorUUID,
            transactionId: transactionId
          )
        case "readDescriptorForService":
          let serviceNumericId =
            try argsHelper.requiredValueFor(.serviceNumericId,
                                        type: Int.self)
          let characteristicUUID =
            try argsHelper.requiredValueFor(.characteristicUuid,
                                            type: String.self)
          let descriptorUUID =
            try argsHelper.requiredValueFor(.descriptorUuid,
                                            type: String.self)
          let transactionId = args?[.transactionId] as? String
          self = .readDescriptorForService(
            serviceNumericId: serviceNumericId,
            characteristicUUID: characteristicUUID,
            descriptorUUID: descriptorUUID,
            transactionId: transactionId
          )
        case "readDescriptorForDevice":
          let deviceId =
            try argsHelper.requiredValueFor(.deviceUuid,
                                            type: String.self)
          let serviceUUID =
            try argsHelper.requiredValueFor(.serviceUuid,
                                            type: String.self)
          let characteristicUUID =
            try argsHelper.requiredValueFor(.characteristicUuid,
                                            type: String.self)
          let descriptorUUID =
            try argsHelper.requiredValueFor(.descriptorUuid,
                                            type: String.self)
          let transactionId = args?[.transactionId] as? String
          self = .readDescriptorForDevice(
            deviceIdentifier: deviceId,
            serviceUUID: serviceUUID,
            characteristicUUID: characteristicUUID,
            descriptorUUID: descriptorUUID,
            transactionId: transactionId
          )
        case "writeDescriptorForIdentifier":
          let descriptorNumericId =
            try argsHelper.requiredValueFor(.descriptorNumericId,
                                            type: Int.self)
          let value =
            try argsHelper.requiredValueFor(.value,
                                            type: FlutterStandardTypedData.self)
          let transactionId = args?[.transactionId] as? String
          self = .writeDescriptorForIdentifier(
            descriptorNumericId: descriptorNumericId,
            value: value,
            transactionId: transactionId
          )
        case "writeDescriptorForCharacteristic":
          let characteristicNumericId =
            try argsHelper.requiredValueFor(.characteristicNumericId,
                                            type: Int.self)
          let descriptorUUID =
            try argsHelper.requiredValueFor(.descriptorUuid,
                                            type: String.self)
          let value =
            try argsHelper.requiredValueFor(.value,
                                            type: FlutterStandardTypedData.self)
          let transactionId = args?[.transactionId] as? String
          self = .writeDescriptorForCharacteristic(
            characteristicNumericId: characteristicNumericId,
            descriptorUUID: descriptorUUID,
            value: value,
            transactionId: transactionId
          )
        case "writeDescriptorForService":
          let serviceNumericId =
            try argsHelper.requiredValueFor(.serviceNumericId,
                                        type: Int.self)
          let characteristicUUID =
            try argsHelper.requiredValueFor(.characteristicUuid,
                                            type: String.self)
          let descriptorUUID =
            try argsHelper.requiredValueFor(.descriptorUuid,
                                            type: String.self)
          let value =
            try argsHelper.requiredValueFor(.value,
                                            type: FlutterStandardTypedData.self)
          let transactionId = args?[.transactionId] as? String
          self = .writeDescriptorForService(
            serviceNumericId: serviceNumericId,
            characteristicUUID: characteristicUUID,
            descriptorUUID: descriptorUUID,
            value: value,
            transactionId: transactionId
          )
        case "writeDescriptorForDevice":
          let deviceId =
            try argsHelper.requiredValueFor(.deviceUuid,
                                            type: String.self)
          let serviceUUID =
            try argsHelper.requiredValueFor(.serviceUuid,
                                            type: String.self)
          let characteristicUUID =
            try argsHelper.requiredValueFor(.characteristicUuid,
                                            type: String.self)
          let descriptorUUID =
            try argsHelper.requiredValueFor(.descriptorUuid,
                                            type: String.self)
          let value =
            try argsHelper.requiredValueFor(.value,
                                            type: FlutterStandardTypedData.self)
          let transactionId = args?[.transactionId] as? String
          self = .writeDescriptorForDevice(
            deviceIdentifier: deviceId,
            serviceUUID: serviceUUID,
            characteristicUUID: characteristicUUID,
            descriptorUUID: descriptorUUID,
            value: value,
            transactionId: transactionId
          )
        default:
          return nil
        }
      }
      
      case isClientCreated
      case createClient(restoreId: String?, showPowerAlert: Bool?)
      case destroyClient
      
      case cancelTransaction(transactionId: Any?)
      
      case getState
      
      case enableRadio
      case disableRadio
      
      case startDeviceScan(uuids: [String]?, allowDuplicates: Bool?)
      case stopDeviceScan
      
      case connectToDevice(deviceIdentifier: String, timoutMillis: Int?)
      case isDeviceConnected(deviceIdentifier: String)
      case observeConnectionState(deviceIdentifier: String,
                                  emitCurrentValue: Bool)
      case cancelConnection(deviceIdentifier: String)
      
      case discoverAllServicesAndCharacteristics(deviceIdentifier: String,
                                                 transactionId: String?)
      case services(deviceIdentifier: String)
      case characteristics(deviceIdentifier: String, serviceUUID: String)
      case characteristicsForService(serviceNumericId: Int)
      case descriptorsForDevice(deviceIdentifier: String,
                                serviceUUID: String,
                                characteristicUUID: String)
      case descriptorsForService(serviceNumericId: Int,
                                 characteristicUUID: String)
      case descriptorsForCharacteristic(characteristicNumericId: Int)
      
      case logLevel
      case setLogLevel(String)
      
      case rssi(deviceIdentifier: String,
                transactionId: String?)
      
      case requestMtu(deviceIdentifier: String,
                      mtu: Int,
                      transactionId: String?)
      
      case getConnectedDevices(serviceUUIDs: [String])
      case getKnownDevices(deviceIdentifiers: [String])
      
      case readCharacteristicForIdentifier(characteristicNumericId: Int,
                                           transactionId: String?)
      case readCharacteristicForDevice(deviceIdentifier: String,
                                       serviceUUID: String,
                                       characteristicUUID: String,
                                       transactionId: String?)
      case readCharacteristicForService(serviceNumericId: Int,
                                        characteristicUUID: String,
                                        transactionId: String?)
      
      case writeCharacteristicForIdentifier(characteristicNumericId: Int,
                                            value: FlutterStandardTypedData,
                                            withResponse: Bool,
                                            transactionId: String?)
      case writeCharacteristicForDevice(deviceIdentifier: String,
                                        serviceUUID: String,
                                        characteristicUUID: String,
                                        value: FlutterStandardTypedData,
                                        withResponse: Bool,
                                        transactionId: String?)
      case writeCharacteristicForService(serviceNumericId: Int,
                                         characteristicUUID: String,
                                         value: FlutterStandardTypedData,
                                         withResponse: Bool,
                                         transactionId: String?)
      
      case monitorCharacteristicForIdentifier(characteristicNumericId: Int,
                                              transactionId: String?)
      case monitorCharacteristicForDevice(deviceIdentifier: String,
                                          serviceUUID: String,
                                          characteristicUUID: String,
                                          transactionId: String?)
      case monitorCharacteristicForService(serviceNumericId: Int,
                                           characteristicUUID: String,
                                           transactionId: String?)
      
      case readDescriptorForIdentifier(descriptorNumericId: Int,
                                       transactionId: String?)
      case readDescriptorForCharacteristic(characteristicNumericId: Int,
                                           descriptorUUID: String,
                                           transactionId: String?)
      case readDescriptorForService(serviceNumericId: Int,
                                    characteristicUUID: String,
                                    descriptorUUID: String,
                                    transactionId: String?)
      case readDescriptorForDevice(deviceIdentifier: String,
                                   serviceUUID: String,
                                   characteristicUUID: String,
                                   descriptorUUID: String,
                                   transactionId: String?)
      
      case writeDescriptorForIdentifier(descriptorNumericId: Int,
                                        value: FlutterStandardTypedData,
                                        transactionId: String?)
      case writeDescriptorForCharacteristic(characteristicNumericId: Int,
                                            descriptorUUID: String,
                                            value: FlutterStandardTypedData,
                                            transactionId: String?)
      case writeDescriptorForService(serviceNumericId: Int,
                                     characteristicUUID: String,
                                     descriptorUUID: String,
                                     value: FlutterStandardTypedData,
                                     transactionId: String?)
      case writeDescriptorForDevice(deviceIdentifier: String,
                                    serviceUUID: String,
                                    characteristicUUID: String,
                                    descriptorUUID: String,
                                    value: FlutterStandardTypedData,
                                    transactionId: String?)
    }
  }
}
