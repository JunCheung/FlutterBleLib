//
//  Client.swift
//  flutter_ble_lib
//
//  Created by Oliver Kocsis on 11/05/2021.
//

import Foundation
import CoreBluetooth

class Client : NSObject {
  
  enum Error : LocalizedError {
    case notCreated
    case invalidUUIDString(String)
    case noPeripheralFoundFor(UUID)
    case peripheralConnection(internal: Swift.Error?)
    case peripheralDisconnection(internal: Swift.Error)

  }
  
  fileprivate class DeviceConnection {
    let peripheral: CBPeripheral
    
    private var connectCompleted: ((_ res: Result<(), Error>) -> ())?
    private var disconnectCompleted: ((_ res: Result<(), Error>) -> ())?
    
    init(_ peripheral: CBPeripheral) {
      self.peripheral = peripheral
    }
    
    func onConnected(_ completion: @escaping (_ res: Result<(), Error>) -> ()) {
      connectCompleted = completion
    }
    func connected(_ res: Result<(), Error>) {
      connectCompleted?(res)
    }
    func onDisconnected(_ completion: @escaping (_ res: Result<(), Error>) -> ()) {
      disconnectCompleted = completion
    }
    func disconnected(_ res: Result<(), Error>) {
      disconnectCompleted?(res)
    }
  }
  
  typealias SignatureEnumT = Descriptors.Method.DefaultChannel.Signature
  
  private var centralManager: CBCentralManager?
  
  private var deviceConnections = [UUID : DeviceConnection]()
  
  var isCreated: Bool {
    return centralManager != nil
  }
  
  func create(restoreId: String?, showPowerAlert: Bool?) {
    var options: [String : Any]?
    if restoreId != nil || showPowerAlert != nil {
      var opts = [String : Any]()
      if let restoreId = restoreId {
        opts[CBCentralManagerOptionShowPowerAlertKey] = restoreId
      }
      if let showPowerAlert = showPowerAlert {
        opts[CBCentralManagerOptionShowPowerAlertKey] = showPowerAlert
      }
      options = opts
    }
    centralManager = CBCentralManager(
      delegate: self,
      queue: nil,
      options: options
    )
  }
  
  func destroy() {
    centralManager?.stopScan()
    centralManager?.delegate = nil
    centralManager = nil
  }
  
  func cancelTransaction(transactionId: Any?) {}
  
  var state : String {
    let unknown = "Unknown"
    switch self.centralManager?.state {
    case .none, .some(.unknown): return unknown
    case .some(let state):
      switch state {
      case .unknown: return unknown
      case .resetting: return "Resetting"
      case .unsupported: return "Unsupported"
      case .unauthorized: return "Unauthorized"
      case .poweredOff: return "PoweredOff"
      case .poweredOn: return "PoweredOn"
      @unknown default: return unknown
      }
    }
  }
  
  func startDeviceScan(withServices services: [String]?, allowDuplicates: Bool?) {
    var options: [String : Any]?
    if let allowDuplicates = allowDuplicates {
      options = [CBCentralManagerScanOptionAllowDuplicatesKey : allowDuplicates]
    }
    centralManager?.scanForPeripherals(
      withServices: services?.map(CBUUID.init(string:)),
      options: options
    )
  }
  
  func stopDeviceScan() {
    centralManager?.stopScan()
  }
  
  func connectToDevice(
    id: String,
    timoutMillis: Int?,
    completion: @escaping (_ completion: Result<(), Error>) -> ()
  ) {
    guard
      let centralManager = centralManager
    else {
      completion(.failure(.notCreated))
      return
    }
    guard
      let peripheralId = UUID(uuidString: id)
    else {
      completion(.failure(Error.invalidUUIDString(id)))
      return
    }
    let peripherals =
      centralManager.retrievePeripherals(withIdentifiers: [peripheralId])
    
    guard
      let peripheral = peripherals.last
    else {
      completion(.failure(.noPeripheralFoundFor(peripheralId)))
      return
    }
    
    var conn: DeviceConnection
    if let c = deviceConnections[peripheralId] {
      conn = c
    } else {
      conn = DeviceConnection(peripheral)
      deviceConnections[peripheralId] = conn
    }
    conn.onConnected { res in
      completion(res)
    }
    // FIXME: support connection option flags
    centralManager.connect(peripheral)
  }
  
  func isDeviceConnected(id: String) -> Result<Bool, Error> {
    guard
      let peripheralId = UUID(uuidString: id)
    else {
      return .failure(Error.invalidUUIDString(id))
    }
    
    if
      let conn = deviceConnections[peripheralId],
      conn.peripheral.state == .connected {
      return .success(true)
    }
    
    if
      let peri =
        centralManager?.retrievePeripherals(withIdentifiers: [peripheralId]).last,
      peri.state == .connected {
      return .success(true)
    }
    return .success(true)
  }
}

extension Client : CallHandler {
  func handle(call: Descriptors.Method.Call<SignatureEnumT>) {
    switch call.signature {
    case .isClientCreated:
      call.result(isCreated)
    case .createClient(let restoreId, let showPowerAlert):
      create(restoreId: restoreId, showPowerAlert: showPowerAlert)
      call.result(nil)
    case .destroyClient:
      destroy()
      call.result(nil)
    case .cancelTransaction(let transactionId):
      cancelTransaction(transactionId: transactionId)
      call.result(nil)
    case .getState:
      call.result(state)
    case .enableRadio:
      call.result(nil)
    case .disableRadio:
      call.result(nil)
    case .startDeviceScan(let uuids, let allowDuplicates):
      startDeviceScan(withServices: uuids, allowDuplicates: allowDuplicates)
      call.result(nil)
    case .stopDeviceScan:
      stopDeviceScan()
      call.result(nil)
    case .connectToDevice(let id, let timoutMillis):
      connectToDevice(id: id, timoutMillis: timoutMillis) { res in
        switch res {
        case .success:
          call.result(nil)
        case .failure(let error):
          call.result(FlutterError(bleError: BleError(withError: error)))
        }
      }
    case .isDeviceConnected(let id):
      let res = isDeviceConnected(id: id)
      switch res {
      case .success(let connected):
        call.result(connected)
      case .failure(let error):
        call.result(FlutterError(bleError: BleError(withError: error)))
      }
    case .observeConnectionState:
      call.result(FlutterMethodNotImplemented)
    case .cancelConnection:
      call.result(FlutterMethodNotImplemented)
    case .discoverAllServicesAndCharacteristics:
      call.result(FlutterMethodNotImplemented)
    case .services:
      call.result(FlutterMethodNotImplemented)
    case .characteristics:
      call.result(FlutterMethodNotImplemented)
    case .characteristicsForService:
      call.result(FlutterMethodNotImplemented)
    case .descriptorsForDevice:
      call.result(FlutterMethodNotImplemented)
    case .descriptorsForService:
      call.result(FlutterMethodNotImplemented)
    case .descriptorsForCharacteristic:
      call.result(FlutterMethodNotImplemented)
    case .logLevel:
      call.result(FlutterMethodNotImplemented)
    case .setLogLevel:
      call.result(FlutterMethodNotImplemented)
    case .rssi:
      call.result(FlutterMethodNotImplemented)
    case .requestMtu:
      call.result(FlutterMethodNotImplemented)
    case .getConnectedDevices:
      call.result(FlutterMethodNotImplemented)
    case .getKnownDevices:
      call.result(FlutterMethodNotImplemented)
    case .readCharacteristicForIdentifier:
      call.result(FlutterMethodNotImplemented)
    case .readCharacteristicForDevice:
      call.result(FlutterMethodNotImplemented)
    case .readCharacteristicForService:
      call.result(FlutterMethodNotImplemented)
    case .writeCharacteristicForIdentifier:
      call.result(FlutterMethodNotImplemented)
    case .writeCharacteristicForDevice:
      call.result(FlutterMethodNotImplemented)
    case .writeCharacteristicForService:
      call.result(FlutterMethodNotImplemented)
    case .monitorCharacteristicForIdentifier:
      call.result(FlutterMethodNotImplemented)
    case .monitorCharacteristicForDevice:
      call.result(FlutterMethodNotImplemented)
    case .monitorCharacteristicForService:
      call.result(FlutterMethodNotImplemented)
    case .readDescriptorForIdentifier:
      call.result(FlutterMethodNotImplemented)
    case .readDescriptorForCharacteristic:
      call.result(FlutterMethodNotImplemented)
    case .readDescriptorForService:
      call.result(FlutterMethodNotImplemented)
    case .readDescriptorForDevice:
      call.result(FlutterMethodNotImplemented)
    case .writeDescriptorForIdentifier:
      call.result(FlutterMethodNotImplemented)
    case .writeDescriptorForCharacteristic:
      call.result(FlutterMethodNotImplemented)
    case .writeDescriptorForService:
      call.result(FlutterMethodNotImplemented)
    case .writeDescriptorForDevice:
      call.result(FlutterMethodNotImplemented)
    }
  }
}

extension Client : CBCentralManagerDelegate {
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    
  }
  
  func centralManager(
    _ central: CBCentralManager,
    willRestoreState dict: [String : Any]
  ) {
    
  }
  
  func centralManager(
    _ central: CBCentralManager,
    didDiscover peripheral: CBPeripheral,
    advertisementData: [String : Any],
    rssi RSSI: NSNumber
  ) {
    
  }
  
  func centralManager(
    _ central: CBCentralManager,
    didConnect peripheral: CBPeripheral
  ) {
    deviceConnections[peripheral.identifier]?.connected(.success(()))
  }
  func centralManager(
    _ central: CBCentralManager,
    didFailToConnect peripheral: CBPeripheral,
    error: Swift.Error?
  ) {
    let conn = deviceConnections[peripheral.identifier]
    conn?.connected(.success(()))
  }
  
  func centralManager(
    _ central: CBCentralManager,
    didDisconnectPeripheral peripheral: CBPeripheral,
    error: Swift.Error?
  ) {
    let conn = deviceConnections[peripheral.identifier]
    if let error = error {
      conn?.connected(
        .failure(Error.peripheralDisconnection(internal: error))
      )
      return
    }
    conn?.disconnected(.success(()))
  }
  
  func centralManager(
    _ central: CBCentralManager,
    connectionEventDidOccur event: CBConnectionEvent,
    for peripheral: CBPeripheral
  ) {
    
  }

  func centralManager(
    _ central: CBCentralManager,
    didUpdateANCSAuthorizationFor peripheral: CBPeripheral
  ) {
    
  }
}
