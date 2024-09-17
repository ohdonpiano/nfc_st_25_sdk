//
//  iOSRFReaderInterface.swift
//  NFCTap 
//
//  Created by STMICROELECTRONICS on 7/31/19.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import Foundation
import CoreNFC
import st25sdkFramework

class iOSRFReaderInterface: NSObject, ComStSt25sdkRFReaderInterface {
    func getTransceivedData() -> JavaUtilList! {
        return nil
    }
    
    func inventory(with mode: ComStSt25sdkRFReaderInterface_InventoryMode!) -> JavaUtilList! {
        return nil
    }
    

    
    
    internal var mNFCSession:NFCTagReaderSession!
    
    internal var miOSIso15693:iOSIso15693!
    internal var miOSMiFare:iOSMifare!
    internal var miOSIso7816:iOSIso7816!
    
    internal var mNdefTag: NFCNDEFTag!
    internal var mIso15693Tag: NFCISO15693Tag!
    internal var mMiFareTag: NFCMiFareTag!
    internal var mIso7816Tag: NFCISO7816Tag!
    
    init(aNFCTag : NFCTag, aSession : NFCTagReaderSession) {
        super.init()
        mNFCSession = aSession
        switch aNFCTag {
           case let .iso7816(tag):
               mNdefTag = tag
               mIso7816Tag = tag .asNFCISO7816Tag()
               self.miOSIso7816 = iOSIso7816(mIso7816Tag, session: aSession)
           case let .feliCa(tag):
               mNdefTag = tag
           case let .iso15693(tag):
               mNdefTag = tag
               mIso15693Tag = tag .asNFCISO15693Tag()!
               self.miOSIso15693 = iOSIso15693(mIso15693Tag, session: aSession)
           case let .miFare(tag):
               mNdefTag = tag
               mMiFareTag = tag .asNFCMiFareTag()!
               miOSMiFare = iOSMifare(mMiFareTag,session: aSession)
           @unknown default:
               return
           }
    }
    
    func sessionInvalidate(){
        mNFCSession.invalidate()
    }
    
    func sessionInvalidate(error: TagError?){
        mNFCSession.invalidate(errorMessage: error!.errorDescription)
    }
    
    func sessionInvalidate(error: String ){
        mNFCSession.invalidate(errorMessage: error)
    }
    
    private func printBuffer (function : String, buffer : Data) {
        #if DEBUG
        #if !APPCLIP
                var myString: NSString?
                myString = "--> Reader Interface \(function) command: \(buffer.toHexString()) " as NSString
                NSLog("%@", myString!);
        #endif
        #endif

    }
    
    
    func transceive(withId obj: Any!, with commandName: String!, with data: IOSByteArray!) -> IOSByteArray! {

        printBuffer(function: "\(#function)-\(#line) \(commandName as Any as! String)", buffer: data.toNSData())
        
        let defaultResponse:Data = Data([0x01, 0x0F])
  
        if commandName.elementsEqual("readSingleBlock"){
            let dataToNSData = data.toNSData()!
            let commandFlag = dataToNSData[0]
            let blockAddresse = dataToNSData[Int(ComStSt25sdkCommandIso15693Protocol_ISO15693_HEADER_SIZE_UID)]

            var response = self.miOSIso15693.readSingleBlockWithFlag(address: UInt8(blockAddresse), flag: commandFlag)
            return (IOSByteArray.init(nsData: response))
        }
        
        if commandName.elementsEqual("readSingleBlockVicinity"){
            var response = Data([0x00, 0x00,0x00,0x00,0x00,0x00,0x00])
            return (IOSByteArray.init(nsData: response as Data))
        }
        
        if commandName.elementsEqual("getSystemInfo"){
            var response = self.miOSIso15693.getSystemInfo()
            return (IOSByteArray.init(nsData: response))
        }
       
        if commandName.elementsEqual("getSystemInfoVicinity"){
            var response = self.miOSIso15693.getSystemInfoVicinity()
            return (IOSByteArray.init(nsData: response))
        }

        if commandName.elementsEqual("readConfig"){
            let dataToNSData = data.toNSData()!
            let commandCode = dataToNSData[1]
            let headerSize = Int(ComStSt25sdkCommandIso15693Protocol_ISO15693_CUSTOM_ST_HEADER_SIZE_UID)
            let configData  = dataToNSData[headerSize...dataToNSData.count-1]
            let response  = self.miOSIso15693.customCommand(code: commandCode, data:configData)
            return (IOSByteArray.init(nsData: response))
        }
        
        if commandName.elementsEqual("writeConfig"){
            let dataToNSData = data.toNSData()!
            
            let commandCode = dataToNSData[1]
            let headerSize = Int(ComStSt25sdkCommandIso15693Protocol_ISO15693_CUSTOM_ST_HEADER_SIZE_UID)
            let configData  = dataToNSData[headerSize...dataToNSData.count-1]
            
            let response  = self.miOSIso15693.customCommand(code: commandCode, data:configData)
            return (IOSByteArray.init(nsData: response))
        }
        
        if commandName.elementsEqual("presentPwd"){
            let dataToNSData = data.toNSData()!
            
            let commandCode = dataToNSData[1]
            let headerSize = Int(ComStSt25sdkCommandIso15693Protocol_ISO15693_CUSTOM_ST_HEADER_SIZE_UID)
            // For 8 bytes
            //let pwdData   = dataToNSData[dataToNSData.count-9...dataToNSData.count-1]
            // For 4 bytes
            //let pwdData   = dataToNSData[dataToNSData.count-5...dataToNSData.count-1]
            let pwdData  = dataToNSData[headerSize...dataToNSData.count-1]
            
            var response  = self.miOSIso15693.customCommand(code: commandCode, data:pwdData)
            return (IOSByteArray.init(nsData: response))
        }
    
        if commandName.elementsEqual("writePwd"){
            let dataToNSData = data.toNSData()!
            
            let commandCode = dataToNSData[1]
            let headerSize = Int(ComStSt25sdkCommandIso15693Protocol_ISO15693_CUSTOM_ST_HEADER_SIZE_UID)
            // For 8 bytes
            //let pwdData   = dataToNSData[dataToNSData.count-9...dataToNSData.count-1]
            // For 4 bytes
            //let pwdData   = dataToNSData[dataToNSData.count-5...dataToNSData.count-1]
            let pwdData  = dataToNSData[headerSize...dataToNSData.count-1]
            
            var response  = self.miOSIso15693.customCommand(code: commandCode, data:pwdData)
            return (IOSByteArray.init(nsData: response))
        }
        
        if commandName.elementsEqual("getRandomNumber") ||
            commandName.elementsEqual("readSignature")
        {
            let dataToNSData = data.toNSData()!
            let commandCode = dataToNSData[1]
            
            var response  = self.miOSIso15693.customCommand(code: commandCode, data:Data())
            return (IOSByteArray.init(nsData: response))
        }
        
        if commandName.elementsEqual("readDynConfig"){
            let dataToNSData = data.toNSData()!
            
            let commandCode = dataToNSData[1]
            let configRegisterAddress = UInt8(dataToNSData[dataToNSData.count-1])
            
            var response  = self.miOSIso15693.customCommand(code: commandCode, data:Data([configRegisterAddress]))
            return (IOSByteArray.init(nsData: response))
        }
        
        
        if commandName.elementsEqual("writeDynConfig"){
            let dataToNSData = data.toNSData()!
            let commandCode = dataToNSData[1]
            let configRegisterAddress = UInt8(dataToNSData[dataToNSData.count-2])
            let configRegisterValue = UInt8(dataToNSData[dataToNSData.count-1])
            
            var response  = self.miOSIso15693.customCommand(code: commandCode, data:Data([configRegisterAddress,configRegisterValue]))
            return (IOSByteArray.init(nsData: response))
        }
        
        if commandName.elementsEqual("writeMsg"){
            let dataToNSData = data.toNSData()!
            
            let commandCode = dataToNSData[1]
            let dataBuffer   = dataToNSData[11...dataToNSData.count-1]
            
            var response  = retryOnError(commandCode: commandCode, dataBuffer: dataBuffer)
            return (IOSByteArray.init(nsData: response))
        }
        
        if commandName.elementsEqual("readMsgLength"){
            let dataToNSData = data.toNSData()!
            
            let commandCode = dataToNSData[1]
            let dataBuffer   = NSData() // Length
            
            var response  = self.miOSIso15693.customCommand(code: commandCode, data:dataBuffer as Data)
            return (IOSByteArray.init(nsData: response))
        }
        
        if commandName.elementsEqual("readMsg"){
            let dataToNSData = data.toNSData()!
            
            let commandCode = dataToNSData[1]
            let dataBuffer   = dataToNSData[dataToNSData.count-2...dataToNSData.count-1]
            
            var response  = self.miOSIso15693.customCommand(code: commandCode, data:dataBuffer as Data)
            return (IOSByteArray.init(nsData: response))
        }
        
        if commandName.elementsEqual("readMultipleBlock"){
            let dataToNSData = data.toNSData()!
            
            let start = UInt8(data.byte(at: UInt(ComStSt25sdkCommandIso15693Protocol_ISO15693_HEADER_SIZE_UID)))
            print("Start : \(start)")
            //UInt8(dataToNSData[headerSize])
            let length = UInt8(data.byte(at: UInt(dataToNSData.count-1))) //UInt8(dataToNSData.count-1)
            print("Length : \(length)")

            let readRange = Range<UInt8>(uncheckedBounds: (lower: start, upper: start+length))
            print("readRange : \(readRange)")

            //let dataBuffer   = dataToNSData[headerSize...dataToNSData.count-1]
            //var response = self.miOSIso15693.customCommand(code: commandCode, data:dataBuffer as Data)
            var response = self.miOSIso15693.readMultipleBlocks(range: readRange)
            return (IOSByteArray.init(nsData: response))
        }
        
        if commandName.elementsEqual("writeSingleBlock"){
            var response : Data!
            
            let dataToNSData = data.toNSData()!
            let addr = dataToNSData[Int(ComStSt25sdkCommandIso15693Protocol_ISO15693_HEADER_SIZE_UID)]
            
            let start = UInt(ComStSt25sdkCommandIso15693Protocol_ISO15693_HEADER_SIZE_UID)+1
            let end = UInt(dataToNSData.count-1)
            
            let dataBuffer   = dataToNSData[start...end]
            
            response = self.miOSIso15693.writeSingleBlock(startAddress: addr, data: dataBuffer)
            return (IOSByteArray.init(nsData: response))
        }
        
        if commandName.elementsEqual("writeMultipleBlock"){
            var response : Data!
            
            let dataToNSData = data.toNSData()!
            let firstBlockNumber = dataToNSData[Int(ComStSt25sdkCommandIso15693Protocol_ISO15693_HEADER_SIZE_UID)]
            let start = UInt(ComStSt25sdkCommandIso15693Protocol_ISO15693_HEADER_SIZE_UID)+1
            let end = UInt(dataToNSData.count-1)
            
            let dataBuffer   = dataToNSData[start...end]
            
            response = self.miOSIso15693.writeMultipleBlocks(startAddress: UInt8(firstBlockNumber), data: dataBuffer)
            return (IOSByteArray.init(nsData: response))
        }
        
        if commandName.elementsEqual("kill"){
            let dataToNSData = data.toNSData()!
            
            let commandCode = dataToNSData[1]
            let headerSize = Int(ComStSt25sdkCommandIso15693Protocol_ISO15693_CUSTOM_ST_HEADER_SIZE_UID)
            let pwdData  = dataToNSData[headerSize...dataToNSData.count-1]
            
            var response  = self.miOSIso15693.customCommand(code: commandCode, data:pwdData)
            return (IOSByteArray.init(nsData: response))
        }
        
        if commandName.elementsEqual("lock kill"){
            let dataToNSData = data.toNSData()!
            let commandCode = dataToNSData[1]
            let headerSize = Int(ComStSt25sdkCommandIso15693Protocol_ISO15693_CUSTOM_ST_HEADER_SIZE_UID)
            let pwdData  = dataToNSData[headerSize...dataToNSData.count-1]
            
            var response  = self.miOSIso15693.customCommand(code: commandCode, data:pwdData)
            return (IOSByteArray.init(nsData: response))
        }
        
        if commandName.elementsEqual("lockBlock"){
            var response : Data!
            let addr = UInt8(data.byte(at: UInt(ComStSt25sdkCommandIso15693Protocol_ISO15693_HEADER_SIZE_UID)))

            response = self.miOSIso15693.lockSingleBlock(address: addr)
            return (IOSByteArray.init(nsData: response))
        }

        if commandName.elementsEqual("extendedLockBlock"){
            var response : Data!
            let dataToNSData = data.toNSData()!
            let headerSize = Int(ComStSt25sdkCommandIso15693Protocol_ISO15693_CUSTOM_ST_HEADER_SIZE_UID-1)
            let blockAddress:UInt16 = UInt16(dataToNSData[headerSize]) + UInt16(dataToNSData[dataToNSData.count-1]) * 256

            response = self.miOSIso15693.extendedlockSingleBlock(address: blockAddress)
            return (IOSByteArray.init(nsData: response))
        }
        
        if commandName.elementsEqual("extendedReadSingleBlock"){
            let dataToNSData = data.toNSData()!
            let commandFlag = dataToNSData[0]
            let headerSize = Int(ComStSt25sdkCommandIso15693Protocol_ISO15693_CUSTOM_ST_HEADER_SIZE_UID-1)
            // Debug purpose - will be used later on, for High density Tags
            //            let adr1 = UInt16(dataToNSData[headerSize])
            //            let adr2 = UInt16(dataToNSData[dataToNSData.count-1])
            //            print("Header index \(headerSize)")
            //            print ("Value at header index : \(adr1)")
            //            print("Cmd length : \(dataToNSData.count-1)")
            //            print ("Value at cmd index : \(adr2)")
            let blockAddress:UInt16 = UInt16(dataToNSData[headerSize]) + UInt16(dataToNSData[dataToNSData.count-1]) * 256
            //print ("blockAddress @ : \(blockAddress)")

            let response = self.miOSIso15693.extendedReadSingleBlockWithOptionFlag(address: blockAddress, flag: commandFlag)
            return (IOSByteArray.init(nsData: response))
        }

        if commandName.elementsEqual("extendedReadMultipleBlock"){
            let dataToNSData = data.toNSData()!
            //let commandFlag = dataToNSData[0]
            let headerSize = Int(ComStSt25sdkCommandIso15693Protocol_ISO15693_CUSTOM_ST_HEADER_SIZE_UID-1)

            // Two first bytes are the @
            let blockAddress:UInt16 = UInt16(dataToNSData[headerSize]) + UInt16(dataToNSData[headerSize+1]) * 256
            //print ("Value @ : \(blockAddress)")
            // two last bytes are the length
            let length = UInt16(dataToNSData[dataToNSData.count-1]) * 256 + UInt16(dataToNSData[dataToNSData.count-2])
            //print ("Length @ : \(length)")
            let readRange = Range<UInt16>(uncheckedBounds: (lower: blockAddress, upper: blockAddress+length))

            var response = self.miOSIso15693.extendedReadMultipleBlocks(range: readRange)
            printBuffer(function: "extendedReadMultipleBlock response", buffer: response!)
            return (IOSByteArray.init(nsData: response))
        }

        if commandName.elementsEqual("extendedWriteSingleBlock"){
            var response : Data!

            let dataToNSData = data.toNSData()!
            let commandFlag = dataToNSData[0]
            let headerSize = Int(ComStSt25sdkCommandIso15693Protocol_ISO15693_CUSTOM_ST_HEADER_SIZE_UID-1)

            // Two first bytes are the @
            let blockAddress:UInt16 = UInt16(dataToNSData[headerSize]) + UInt16(dataToNSData[headerSize+1]) * 256
            //print ("Value @ : \(blockAddress)")
            // two last bytes are the length
 
            let start = UInt(ComStSt25sdkCommandIso15693Protocol_ISO15693_HEADER_SIZE_UID)+2
            let end = UInt(dataToNSData.count-1)
            
            let dataBuffer   = dataToNSData[start...end]

            response = self.miOSIso15693.extendedWriteSingleBlock(startAddress: blockAddress, data: dataBuffer)
            return (IOSByteArray.init(nsData: response))
        }
        
        if commandName.elementsEqual("extendedWriteMultipleBlock"){
            var response : Data!

            let dataToNSData = data.toNSData()!
            let commandFlag = dataToNSData[0]
            let headerSize = Int(ComStSt25sdkCommandIso15693Protocol_ISO15693_CUSTOM_ST_HEADER_SIZE_UID-1)

            // Two first bytes are the @
            let blockAddress:UInt16 = UInt16(dataToNSData[headerSize]) + UInt16(dataToNSData[headerSize+1]) * 256
            //print ("Value @ : \(blockAddress)")
            // two last bytes are the length
            let length = UInt16(dataToNSData[headerSize+2]) + UInt16(dataToNSData[headerSize+3]) * 256
            //print ("Length @ : \(length)")

            let data  = dataToNSData[headerSize+4...dataToNSData.count-1]
            //print ("Data : \(data.toHexString())")

            response = self.miOSIso15693.extendedWriteMultipleBlock(startAddress: blockAddress, data: data)
            return (IOSByteArray.init(nsData: response))
        }
        
        if commandName.elementsEqual("enableUntraceableMode"){
            let dataToNSData = data.toNSData()!
            let flags = dataToNSData[0]
            let commandCode = dataToNSData[1]
              
            // Must be used in addressed Mode Only
            let pwdData  = dataToNSData[3...dataToNSData.count-1]
              
            var response  = self.miOSIso15693.customCommandWithFlags(flags: RequestFlag(rawValue: NFCISO15693RequestFlag.RawValue(Int(flags))), code: UInt8(Int(commandCode)), data: pwdData)
              
            return (IOSByteArray.init(nsData: response))
          }
        
        if commandName.elementsEqual("toggleUntraceableMode"){
          let dataToNSData = data.toNSData()!
          let flags = dataToNSData[0]
          let commandCode = dataToNSData[1]
            
          // Must be used in addressed Mode Only
          let pwdData  = dataToNSData[3...dataToNSData.count-1]
            
          var response  = self.miOSIso15693.customCommandWithFlags(flags: RequestFlag(rawValue: NFCISO15693RequestFlag.RawValue(Int(flags))), code: UInt8(Int(commandCode)), data: pwdData)
            
          return (IOSByteArray.init(nsData: response))
        }
  
        
        if commandName.elementsEqual("write kill"){
          let dataToNSData = data.toNSData()!
          
          let commandCode = dataToNSData[1]
          let headerSize = Int(ComStSt25sdkCommandIso15693Protocol_ISO15693_CUSTOM_ST_HEADER_SIZE_UID)
          let pwdData  = dataToNSData[headerSize...dataToNSData.count-1]
          var response  = self.miOSIso15693.customCommand(code: commandCode, data:pwdData)
          return (IOSByteArray.init(nsData: response))
        }
       
        if commandName.elementsEqual("writeEasId"){
            let dataToNSData = data.toNSData()!
            
            let commandCode = dataToNSData[1]
            let headerSize = Int(ComStSt25sdkCommandIso15693Protocol_ISO15693_CUSTOM_ST_HEADER_SIZE_UID)
            let dataBuffer  = dataToNSData[headerSize...dataToNSData.count-1]
            
            var response  = self.miOSIso15693.customCommand(code: commandCode, data:dataBuffer)
            return (IOSByteArray.init(nsData: response))
        }
        
        if commandName.elementsEqual("writeEasConfig"){
            let dataToNSData = data.toNSData()!
            
            let commandCode = dataToNSData[1]
            let headerSize = Int(ComStSt25sdkCommandIso15693Protocol_ISO15693_CUSTOM_ST_HEADER_SIZE_UID)
            let dataBuffer  = dataToNSData[headerSize...dataToNSData.count-1]
            
            var response  = self.miOSIso15693.customCommand(code: commandCode, data:dataBuffer)
            return (IOSByteArray.init(nsData: response))
        }

        if commandName.elementsEqual("enableEAS"){
            let dataToNSData = data.toNSData()!
            
            var requestFlag:RequestFlag = [.highDataRate]
            let commandCode = dataToNSData[1]
            let headerSize = Int(ComStSt25sdkCommandIso15693Protocol_ISO15693_CUSTOM_ST_HEADER_SIZE_UID)
            var dataBuffer = Data()
            if ((dataToNSData[0] & 0x40) != 0x00) {
                requestFlag = [.highDataRate,.option]
                dataBuffer  = dataToNSData[headerSize...dataToNSData.count-1]
            }

            var response  = self.miOSIso15693.customCommandWithFlags(flags: requestFlag, code: commandCode, data:dataBuffer)
            return (IOSByteArray.init(nsData: response))
        }

        if commandName.elementsEqual("lockEas"){
            let dataToNSData = data.toNSData()!
            
            let commandCode = dataToNSData[1]
            let headerSize = Int(ComStSt25sdkCommandIso15693Protocol_ISO15693_CUSTOM_ST_HEADER_SIZE_UID)
            
            var response  = self.miOSIso15693.customCommand(code: commandCode, data:Data())
            return (IOSByteArray.init(nsData: response))
        }

        if commandName.elementsEqual("resetEas"){
            let dataToNSData = data.toNSData()!
            
            let commandCode = dataToNSData[1]
            let headerSize = Int(ComStSt25sdkCommandIso15693Protocol_ISO15693_CUSTOM_ST_HEADER_SIZE_UID)
            
            var response  = self.miOSIso15693.customCommand(code: commandCode, data:Data())
            return (IOSByteArray.init(nsData: response))
        }

        if commandName.elementsEqual("setEas"){
            let dataToNSData = data.toNSData()!
            
            let commandCode = dataToNSData[1]
            let headerSize = Int(ComStSt25sdkCommandIso15693Protocol_ISO15693_CUSTOM_ST_HEADER_SIZE_UID)
            
            var response  = self.miOSIso15693.customCommand(code: commandCode, data:Data())
            return (IOSByteArray.init(nsData: response))
        }
        
        if commandName.elementsEqual("extendedGetSystemInfo"){
            if #available(iOS 14.0, *) {

                var response = self.miOSIso15693.getExtendedSystemInfo()
                return (IOSByteArray.init(nsData: response))
                
            } else {
                // Fallback on earlier versions
                var response = self.miOSIso15693.getSystemInfo()
                return (IOSByteArray.init(nsData: response))
            }
        }
        
        if commandName.elementsEqual("writeAFI"){
            let dataToNSData = data.toNSData()!
            
            var requestFlag:RequestFlag = [.highDataRate]
            let commandCode = dataToNSData[1]
            let headerSize = Int(ComStSt25sdkCommandIso15693Protocol_ISO15693_CUSTOM_ST_HEADER_SIZE_UID)
            var value = dataToNSData[dataToNSData.count-1]
            if ((dataToNSData[0] & 0x40) != 0x00) {
                requestFlag = [.highDataRate,.option]
            }

            var response  = self.miOSIso15693.writeAFI(requestFlags: requestFlag, afi: value)
            return (IOSByteArray.init(nsData: response))
        }
        if commandName.elementsEqual("writeDSFID"){
            let dataToNSData = data.toNSData()!
            
            var requestFlag:RequestFlag = [.highDataRate]
            let commandCode = dataToNSData[1]
            let headerSize = Int(ComStSt25sdkCommandIso15693Protocol_ISO15693_CUSTOM_ST_HEADER_SIZE_UID)
            var value = dataToNSData[dataToNSData.count-1]
            if ((dataToNSData[0] & 0x40) != 0x00) {
                requestFlag = [.highDataRate,.option]
            }


            var response  = self.miOSIso15693.writeDSFID(requestFlags: requestFlag, dsfid: value)
            return (IOSByteArray.init(nsData: response))
        }
        
        if commandName.elementsEqual("lockAFI"){
            let dataToNSData = data.toNSData()!
            
            var requestFlag:RequestFlag = [.highDataRate]
            let commandCode = dataToNSData[1]
            let headerSize = Int(ComStSt25sdkCommandIso15693Protocol_ISO15693_CUSTOM_ST_HEADER_SIZE_UID)
            if ((dataToNSData[0] & 0x40) != 0x00) {
                requestFlag = [.highDataRate,.option]
            }

            var response  = self.miOSIso15693.lockAFI(requestFlags: requestFlag)
            return (IOSByteArray.init(nsData: response))
        }

        if commandName.elementsEqual("lockDSFID"){
            let dataToNSData = data.toNSData()!
            
            var requestFlag:RequestFlag = [.highDataRate]
            let commandCode = dataToNSData[1]
            let headerSize = Int(ComStSt25sdkCommandIso15693Protocol_ISO15693_CUSTOM_ST_HEADER_SIZE_UID)
            if ((dataToNSData[0] & 0x40) != 0x00) {
                requestFlag = [.highDataRate,.option]
            }

            var response = self.miOSIso15693.lockDSFID(requestFlags: requestFlag)
            return (IOSByteArray.init(nsData: response))
        }
        
        //if commandName.contains("type2_"){
        if (self.miOSMiFare != nil){
            let dataToNSData = data.toNSData()!
            
            let response  = self.miOSMiFare.sendMiFareCommand(commandPacket: dataToNSData)
            return (IOSByteArray.init(nsData: response))
        }
        
        //Type4 commands
        if (self.miOSIso7816 != nil){
            let dataToNSData = data.toNSData()!

            let response  = self.miOSIso7816.sendISO7816Command(dataToNSData)
            //print(response?.toHexString())
            return (IOSByteArray.init(nsData: response))
        }
      
        self.sessionInvalidate(error: "command not implemented")
        printBuffer(function: "\(#function)-\(#line) command not implemented \(commandName as Any as! String)", buffer: data.toNSData())

        return IOSByteArray.init(nsData: defaultResponse)
    }

    private func retryOnError (commandCode : UInt8, dataBuffer : Data) -> Data! {
        var response : Data!
        var retry = 3
        while retry >= 0 {
            response  = self.miOSIso15693.customCommand(code: commandCode, data:dataBuffer)
            if (response != nil && response[0] != 0x00){
                // nothing to do ... retry
                // response has failed
            }else{
                retry = -1
            }
            retry = retry - 1
        }
        return response
    }
    
    func setTransceiveModeWith(_ mode: ComStSt25sdkRFReaderInterface_TransceiveMode!) {
        // not used
    }
    
    func getMaxTransmitLengthInBytes() -> jint {
        // need to be checked at RF interface
        // value returned by Android ... according to Phone
        return 246
    }
    
    func getMaxReceiveLengthInBytes() -> jint {
        return 32
    }
    
    
    func getTransceiveMode() -> ComStSt25sdkRFReaderInterface_TransceiveMode! {
        return ComStSt25sdkRFReaderInterface_TransceiveMode.NORMAL
    }
    
    
    func getLastTransceivedData() -> IOSByteArray! {
        return nil
    }
    
    func getTechList(with uid: IOSByteArray!) -> IOSObjectArray! {
        return nil
    }

    func decodeTagType(with uid: IOSByteArray) -> ComStSt25sdkNFCTag_NfcTagTypes {
        if (miOSIso15693 != nil){
            return ComStSt25sdkNFCTag_NfcTagTypes.NFC_TAG_TYPE_V
        }else if (miOSMiFare != nil){
            return ComStSt25sdkNFCTag_NfcTagTypes.NFC_TAG_ISO14443A_TYPE2_TYPE4A
        }else if (mIso7816Tag != nil){
            return ComStSt25sdkNFCTag_NfcTagTypes.NFC_TAG_TYPE_4A
        }else{
            return ComStSt25sdkNFCTag_NfcTagTypes.NFC_TAG_TYPE_UNKNOWN
        }
    }
    
    func setTagResponseLengthInBytesWith(_ responseDataLengthInBytes: jint) {
        // not used
    }
    
    func iso14443aSelectTag(with uid: IOSByteArray!) -> jbyte {
        if (mIso7816Tag != nil){
            return 0x20
        }else{
            return 0x00
        }
    }
    
    func iso14443bSelectTag(with pupi: IOSByteArray!) -> jbyte {
        return 0
    }
    
    func iso14443aDeSelectTag(with uid: IOSByteArray!) -> jbyte {
        return 0
    }
    
    func iso14443bDeSelectTag(with pupi: IOSByteArray!) -> jbyte {
        return 0
    }
    
}
