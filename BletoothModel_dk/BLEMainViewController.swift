//
//  ViewController.swift
//  BletoothModel_dk
//
//  Created by DennisKao on 2019/9/11.
//  Copyright © 2019 DennisKao. All rights reserved.
//

import UIKit

class BLEMainViewController: UIViewController {

    func
    
    var bleManager: DKBleManager?
    var bleNfcDevice: DKBleNfcDevice?
    var mNearestBle: CBPeripheral?
    
//    @IBAction func findPeripheral(_ sender: UIButton) {
//        self.bleManager!.connect(self.mNearestBle, callbackBlock: { (isconnected) in
//            if isconnected{
//                print("連接成功")
//            }else{
//                print("連接失敗")
//            }
//        })
//    }
    
    @IBOutlet weak var textLog: UITextView!
    
    @IBAction func AutoScanRFID(_ sender: UIButton) {
        if !self.bleManager!.isConnect() {
            self.textLog.text.append(contentsOf: "未連上藍牙")
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            do{
                if let isFindingRFID = try? self.bleNfcDevice?.startAutoSearchCard(20, cardType: UInt8(ISO14443_P4)){
                    
                }
            }catch{
                
            }
        }
        
        
        
        
        
        
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 藍牙實體化＆開始接收delegate來的訊號
        self.bleManager = DKBleManager.sharedInstance()
        self.bleManager?.delegate = self
        
        self.bleNfcDevice = DKBleNfcDevice.init(delegate: self)
        
//        findNearBle()
    }
    
    // 找尋最近的藍牙設備
    func findNearBle(){
        print("尋找藍牙")
        self.bleManager!.startScan()
        if (self.bleManager!.isScanning()){
            print("正在尋找設備")
        }
    }
    
    // 取得藍芽裝置信息
    func getBLEDeviceMsg(){
        // 設備名稱
        let deviceName = self.bleNfcDevice?.getName()
        self.textLog.text.append(contentsOf: "設備名稱：\(deviceName ?? "獲取設備名稱失敗")\n")
        
        // 人家寫的getBatteryVoltage規定不能在主線程跑
        DispatchQueue.global(qos: .background).async {
            let deviceBattery = self.bleNfcDevice?.getBatteryVoltage()
            // 外觀只能在主線程
            DispatchQueue.main.async {
                self.textLog.text.append(contentsOf: "電池電壓：\(round(deviceBattery!*100)/100)")
            }
        }
    

    }
}



extension BLEMainViewController: DKBleManagerDelegate, DKBleNfcDeviceDelegate{
    
    func dkScannerCallback(_ central: CBCentralManager!, didDiscover peripheral: CBPeripheral!, advertisementData: [AnyHashable : Any]!, rssi RSSI: NSNumber!) {
        
        print("「發現外圍設備」的 delegate")
        
        if peripheral.name == "BLE_NFC"{
            print("找到 BLE_NFC")
            self.mNearestBle = peripheral
            self.bleManager?.connect(peripheral, callbackBlock: { (isConnected) in
                if isConnected{
                    print("連接成功")
                    self.bleManager?.stopScan()
                    self.getBLEDeviceMsg()
//                    self.textLog.text = String(describing: peripheral.services)
                    
                }else{ print("連接失敗")}
            })
        }
    }
    
    func dkCentralManagerDidUpdateState(_ central: CBCentralManager!) {
        switch central.state {
        
        case .unknown:
            print("未知狀態")
        case .resetting:
            print("重置中")
        case .unsupported:
            print("不支援")
        case .unauthorized:
            print("未驗證")
        case .poweredOff:
            print("尚未啟動")
        case .poweredOn:
            print("藍芽已開啟")
            self.findNearBle()
        @unknown default:
            print("未知的藍芽狀態")
        }
    }
    
    // TODO: 還沒用到
    func dkCentralManagerConnectState(_ central: CBCentralManager!, state: Bool) {
        print("ConnectState---- ")
//        if state {
//            print("連線成功！")
//        }else{
//            print("連線失敗")
//        }
    }

    
    func receiveRfnSearchCard(_ isblnIsSus: Bool, cardType: UInt, uid CardSn: Data!, ats bytCarATS: Data!) {
    
    }
    
    
}

