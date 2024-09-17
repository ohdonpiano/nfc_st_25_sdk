//
//  iOSIso15693.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 9/9/19.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import Foundation
import UIKit
import CoreNFC

extension Data {
    func toHexString() -> String {
        return map { String(format: "%02hhx ", $0) }.joined()
    }
}

public enum TagError: Error {
    case ResponseError(String)
    case Success
    case InvalidResponse
    case UnexpectedError
    case NotImplemented

    var errorDescription: String { return "Invalid response" }
}

@available(iOS 13, *)
class iOSIso15693: NSObject {
        
    private var mResponseBuffer:Data?
    private var mCommandStatus:TagError?
    private var mSemaphoreFunction:DispatchSemaphore = DispatchSemaphore.init(value: 1)
    private var mSemaphoreBuffer:DispatchSemaphore = DispatchSemaphore.init(value: 0)

    // NDEF Infos
    private var mNdefStatus: NFCNDEFStatus?
    private var mNdefCapacity:Int?
    private var mNdefError: Error?
    
    
    typealias handlerResults = (_ responseBuffer : Data?, _ tagError: TagError?)->()
    typealias handlerResultsQueryNdef = (_ ndefStatus: NFCNDEFStatus, _ capacity:Int, _ error: Error?)->()
    
    private var mTag: NFCISO15693Tag!
    private var mSession:NFCTagReaderSession!
    
    override init(){
        super.init()
        self.mTag = nil
        //self.mSession = nil
    }

    init(_ tag:NFCISO15693Tag){
        super.init()
        self.mTag = tag
        self.mSession = nil
    }
    
    
    init(_ tag:NFCISO15693Tag, session:NFCTagReaderSession){
           super.init()
           self.mTag = tag
           self.mSession = session
       }
    
    var id:Data?{
        get{
            return mTag?.identifier
        }
    }
    
    private func printBuffer (function : String, buffer : Data) {
#if DEBUG
#if !APPCLIP
        var myString: NSString?
        myString = "--> \(function) answer: \(buffer.toHexString()) " as NSString
        NSLog("%@", myString!);
#endif
#endif

    }
    
    func sessionRestartPolling(){
        mSession.restartPolling()
    }

    
    func sessionInvalidate(){
        self.sessionInvalidate(session: mSession)
    }
    
    func sessionInvalidate(error: TagError?){
        self.sessionInvalidate(session: mSession, error: error)
    }
    
    func sessionInvalidate(session: NFCTagReaderSession){
        self.semaphoreFunctionWait()
        session.invalidate()
        self.semaphoreFunctionSignal()
    }
    
    func sessionInvalidate(session: NFCTagReaderSession, error: TagError? ){
        self.semaphoreFunctionWait()
        if error != nil{
            session.invalidate(errorMessage: error!.errorDescription)
         }else{
            session.invalidate()
        }
        self.semaphoreFunctionSignal()
    }

    func sessionInvalidate(error: String ){
        self.semaphoreFunctionWait()
        mSession.invalidate(errorMessage: error)
        self.semaphoreFunctionSignal()
    }

    // Completion handler
    private func completionHandlerRead(responseRead: Data?,error: TagError?) {
        self.mResponseBuffer = responseRead
        self.mCommandStatus = error
        self.semaphoreBufferSignal()
    }
    
    private func completionHandlerWrite(responseWrite: Data?,error: TagError?) {
        self.mResponseBuffer = responseWrite
        self.mCommandStatus = error
        self.semaphoreBufferSignal()
    }

    private func completionHandlerQueryNdef(ndefStatus: NFCNDEFStatus, capacity:Int, error: Error?) {
        mNdefStatus = ndefStatus
        mNdefCapacity = capacity
        mNdefError = error
        self.semaphoreBufferSignal()
    }

    private func createErrorResponseBuffer(error :NFCReaderError, debugCodeLocationInformation: String)->Data {
            let tagErrorValue = self.extractIso15693ErrorCode(error :error)
            let foo:[UInt8] = [0x01,UInt8(tagErrorValue)]
            self.printBuffer(function: debugCodeLocationInformation, buffer: Data(foo))
            return (Data(foo))
    }
    
    private func extractIso15693ErrorCode(error :NFCReaderError) -> Int {
        var errorValue: Int = 0x0F
        if let  iso15693ErrorValue: Dictionary<String, AnyObject> =  error.errorUserInfo as? Dictionary<String, AnyObject> {
            if iso15693ErrorValue["ISO15693TagResponseErrorCode"] != nil {
                errorValue = iso15693ErrorValue["ISO15693TagResponseErrorCode"] as! Int
            }
        }
        return errorValue
    }
    
    class responseWithError {
        var mResponse: Data
        var mError: TagError
        init(response : Data, error: TagError) {
            mResponse = response
            mError = error
        }
    }
    
    // Response Buffer Wait
    private func getBufferResponse() -> Data? {
        self.semaphoreBufferWait()
        return self.mResponseBuffer
    }
    
    private func getCommandStatus() -> TagError? {
        self.semaphoreBufferWait()
        //print(">>>> getCommandStatus")
        return self.mCommandStatus
   }
    private func getBufferResponseWithStatus() -> responseWithError? {
        self.semaphoreBufferWait()
        //print(">>>> getCommandStatus")
        return responseWithError.init(response: self.mResponseBuffer!, error: self.mCommandStatus!)
   }
    
   // getSystemInfo
    func getSystemInfo() -> Data? {
        self.getSystemInfo(onComplete: self.completionHandlerRead)
        return getBufferResponse()
    }
    
    func getSystemInfo(onComplete:@escaping handlerResults) {
        self.semaphoreFunctionWait()

        self.mTag.getSystemInfo(requestFlags: [.address, .highDataRate])
        {  dfsid,afi,blockSize,nbBlock,icRef,error in
            if let error = error as? NFCReaderError {
                onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
             }
            else{
                var response:Data = Data([0x00, 0x0F])
                response.append(self.mTag.identifier)
                response.append(UInt8(dfsid))
                response.append(UInt8(afi))
                if nbBlock != -1 {
                    response.append(UInt8(nbBlock-1))
                    response.append(UInt8(blockSize))

                } else {
                    response.append(0xFF)
                    response.append(0xFF)
                }
                
                response.append(UInt8(icRef))
                onComplete(response,nil)
            }
            self.semaphoreFunctionSignal()
            }
    }

    // getSystemInfoVicinity
     func getSystemInfoVicinity() -> Data? {
         self.getSystemInfoVicinity(onComplete: self.completionHandlerRead)
         return getBufferResponse()
     }
     
     func getSystemInfoVicinity(onComplete:@escaping handlerResults) {
         self.semaphoreFunctionWait()

        self.mTag.getSystemInfo(requestFlags: [.address, .highDataRate,.protocolExtension])
         {  dfsid,afi,blockSize,nbBlock,icRef,error in
             if let error = error as? NFCReaderError {
                 onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
              }
             else{
                 var response:Data = Data([0x00, 0x0F])
                 response.append(self.mTag.identifier)
                 response.append(UInt8(dfsid))
                 response.append(UInt8(afi))
                 if nbBlock != -1 {
                     response.append(UInt8(nbBlock-1))
                     response.append(UInt8(blockSize))

                 } else {
                     response.append(0xFF)
                     response.append(0xFF)
                 }
                 
                 response.append(UInt8(icRef))
                 onComplete(response,nil)
             }
             self.semaphoreFunctionSignal()
             }
     }
    
    func getExtendedSystemInfo() -> Data? {
        self.getExtendedSystemInfo(onComplete: self.completionHandlerRead)
        return getBufferResponse()

    }

    func getExtendedSystemInfo(onComplete:@escaping handlerResults) {
        let commandFlag = 0x02
        let commandCode = 0x3B
        let commandParams:Data = Data([0x3F])

        let response = self.sendRequest(requestFlags: Int(commandFlag), commandCode: Int(commandCode), data: commandParams)
        onComplete(response,nil)
    }
    
   // Custom Commands
    func customCommand(code:UInt8, data:Data) -> Data? {
        self.customCommand(code:code, data:data, onComplete: self.completionHandlerRead)
        return getBufferResponse()
     }
    
    func customCommand(code:UInt8, data:Data, onComplete:@escaping handlerResults) {
         self.semaphoreFunctionWait()
        self.mTag.customCommand(requestFlags: [.highDataRate], customCommandCode: Int(code),customRequestParameters:data)
         { response, error in
                if let error = error as? NFCReaderError {
                    onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
                }else{
                    var foo = response
                    foo.insert(0x00, at: 0)
                    onComplete(Data(foo),nil)
                }
                self.semaphoreFunctionSignal()
            }
     }
    
    func customCommandWithFlags(flags:RequestFlag, code:UInt8, data:Data) -> Data? {
        //print ("flags : \(flags)")
        //print ("code : \(code)")
        //print ("IC : \(self.mTag.icManufacturerCode)")
        //print ("Data : \(data.toHexString())")
        self.customCommandWithFlags(flags:flags,code:code, data:data, onComplete: self.completionHandlerRead)
        return getBufferResponse()
     }
    
    func customCommandWithFlags(flags:RequestFlag,code:UInt8, data:Data, onComplete:@escaping handlerResults) {
         self.semaphoreFunctionWait()
        self.mTag.customCommand(requestFlags: flags, customCommandCode: Int(code),customRequestParameters:data)
         { response, error in
                if let error = error as? NFCReaderError {
                    onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
                }else{
                    var foo = response
                    foo.insert(0x00, at: 0)
                    onComplete(Data(foo),nil)
                }
                self.semaphoreFunctionSignal()
            }
     }
    
   // ISO 15693 READ APIs
   func readSingleBlock(address: UInt8) -> Data? {
         //print(">>>> readSingleBlock")
         self.readSingleBlock(requestFlags: [.address, .highDataRate], address: address, onComplete: self.completionHandlerRead)
         return getBufferResponse()
    }
    func readSingleBlockWithFlag(address: UInt8, flag : UInt8) -> Data? {
          //print(">>>> readSingleBlock")
        self.readSingleBlock(requestFlags: RequestFlag(rawValue: flag), address: address, onComplete: self.completionHandlerRead)
          return getBufferResponse()
     }
    
    private func readSingleBlock(requestFlags flags: RequestFlag, address: UInt8, onComplete:@escaping handlerResults) {
        self.semaphoreFunctionWait()
        self.mTag.readSingleBlock(requestFlags: flags, blockNumber: address)
        { data, error in
            if let error = error as? NFCReaderError {
                onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
            }else{
                var foo = data
                foo.insert(0x00, at: 0)
                onComplete(Data(foo), nil)
                
            }
            self.semaphoreFunctionSignal()
        }
    }

    func lockSingleBlock(address: UInt8) -> Data? {
          //print(">>>> lockSingleBlock")
          self.lockSingleBlock(address: address, onComplete: self.completionHandlerRead)
          return getBufferResponse()
     }
    
     private func lockSingleBlock(address:UInt8, onComplete:@escaping handlerResults) {
        self.semaphoreFunctionWait()
        mTag.lockBlock(requestFlags: [.address,.highDataRate], blockNumber: UInt8(address)){ error in
            if let error = error as? NFCReaderError {
                 onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
             }else{
                 let foo:[UInt8] = [UInt8(0)]
                 onComplete(Data(foo),nil)
             }
            self.semaphoreFunctionSignal()
        }
    }

    
    func readMultipleBlocks(range: Range<UInt8>) -> Data? {
        self.readMultipleBlocks(range:range, onComplete: self.completionHandlerRead)
        return getBufferResponse()
     }

    
    func readMultipleBlocks(range: Range<UInt8>, onComplete:@escaping handlerResults) {
        self.semaphoreFunctionWait()
        mTag.readMultipleBlocks(requestFlags:  [.address,.highDataRate],blockRange: NSRange(range))
        { data, error in
            if let error = error as? NFCReaderError {
                onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
            }else{
                var mergedData = Data(capacity: data.count*4)
                data.forEach{ cellData in
                    mergedData.append(cellData)
                }
                mergedData.insert(0x00, at: 0)
                onComplete(mergedData,nil)
            }
            self.semaphoreFunctionSignal()
        }
    }
    
    func readMultipleBlocks(range: Range<UInt16>) -> Data? {
        self.readMultipleBlocks(range:range, onComplete: self.completionHandlerRead)
        return getBufferResponse()
     }

    
    func readMultipleBlocks(range: Range<UInt16>, onComplete:@escaping handlerResults) {
        self.semaphoreFunctionWait()
        mTag.readMultipleBlocks(requestFlags:  [.address,.highDataRate],blockRange: NSRange(range))
        { data, error in
            if let error = error as? NFCReaderError {
                onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
            }else{
                var mergedData = Data(capacity: data.count*4)
                data.forEach{ cellData in
                    mergedData.append(cellData)
                }
                mergedData.insert(0x00, at: 0)
                onComplete(mergedData,nil)
            }
            self.semaphoreFunctionSignal()
        }
    }
    
    func extendedReadSingleBlock(address: UInt16) -> Data? {
        self.extendedReadSingleBlock(requestFlags: [.address,.highDataRate], address: address, onComplete: self.completionHandlerRead)
        return getBufferResponse()
    }
    func extendedReadSingleBlockWithOptionFlag(address: UInt16, flag : UInt8) -> Data? {
        self.extendedReadSingleBlock(requestFlags: RequestFlag(rawValue: flag), address: address, onComplete: self.completionHandlerRead)
        return getBufferResponse()
    }
    
    private func extendedReadSingleBlock(requestFlags flags: RequestFlag, address: UInt16, onComplete:@escaping handlerResults) {
        self.semaphoreFunctionWait()
        self.mTag.extendedReadSingleBlock(requestFlags: flags , blockNumber: Int(address))
        { data, error in
             if let error = error as? NFCReaderError {
                onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))

            }else{
                var foo = data
                foo.insert(0x00, at: 0)
                onComplete(Data(foo), nil)
            }
            self.semaphoreFunctionSignal()
        }//extendedReadSingleBlock
    }
    
    func extendedReadMultipleBlocks(range: Range<UInt16>) -> Data? {
        self.extendedReadMultipleBlocks(range: range,onComplete: self.completionHandlerRead)
        return getBufferResponse()
    }
    
    func extendedReadMultipleBlocks(range: Range<UInt16>, onComplete:@escaping handlerResults) {
        self.semaphoreFunctionWait()
        mTag.extendedReadMultipleBlocks(requestFlags:  [.address,.highDataRate],blockRange: NSRange(range))
        { data, error in
             if let error = error as? NFCReaderError {
                onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
            }else{
                var mergedData = Data(capacity: data.count*4)
                data.forEach{ cellData in
                    mergedData.append(cellData)
                }
                mergedData.insert(0x00, at: 0)
                onComplete(mergedData,nil)
            }
            self.semaphoreFunctionSignal()
        }
    }

    func extendedWriteMultipleBlock(startAddress:UInt16, data:Data) -> Data? {
        extendedWriteMultipleBlock(startAddress: startAddress, data:data,onComplete: self.completionHandlerWrite)
        return getBufferResponse()
    }
    
    func extendedWriteMultipleBlock(startAddress:UInt16, data:Data, onComplete:@escaping handlerResults){
        self.semaphoreFunctionWait()

        var dataBlock:[Data] = [Data]()
        dataBlock = sliceDataBuffer(data: Data(data), chunckSize: 4)
        let blockRange = NSRange(location: Int(startAddress), length: dataBlock.count)

        if #available(iOS 14.0, *) {
            mTag.extendedWriteMultipleBlocks(requestFlags: [.address,.highDataRate], blockRange: blockRange, dataBlocks: dataBlock){ error in
                if let error = error as? NFCReaderError {
                    onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
                }else{
                    let foo:[UInt8] = [UInt8(0)]
                    onComplete(Data(foo),nil)
                }
                self.semaphoreFunctionSignal()
            }
        } else {
            // Fallback on earlier versions
            let foo:Data = Data([0x01, 0x0F])
            onComplete(foo,nil)
        }
    }
        
    // ST25 DV-I2C FAST READS : Specific to ST25DV-I2C using Custom Commands
    func fastReadSingleBlock(address: UInt8) -> Data? {
        self.fastReadSingleBlock(address: address,onComplete: self.completionHandlerRead)
        return getBufferResponse()
    }
    
    func fastReadSingleBlock(address: UInt8, onComplete:@escaping handlerResults) {
        self.semaphoreFunctionWait()
        mTag.customCommand(requestFlags: [.highDataRate], customCommandCode: 0xC0, customRequestParameters: Data([address])){ (response: Data, error: Error?) in
             if let error = error as? NFCReaderError {
                onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
            }else{
                var foo = response
                foo.insert(0x00, at: 0)
                onComplete(Data(foo), nil)
            }
        }
        self.semaphoreFunctionSignal()
    }

    func fastReadMultipleBlocks(range: Range<UInt8>) -> Data? {
        self.fastReadMultipleBlocks(range: range,onComplete: self.completionHandlerRead)
        return getBufferResponse()
    }

    func fastReadMultipleBlocks(range: Range<UInt8>, onComplete:@escaping handlerResults) {
        self.semaphoreFunctionWait()
        mTag.fastReadMultipleBlocks(requestFlags: [.address,.highDataRate], blockRange: NSRange(range) ){
            result in
            switch result {
            case .success(let data):
                var mergedData = Data(capacity: data.count*4)
                data.forEach{ cellData in
                    mergedData.append(cellData)
                }
                //mergedData.insert(0x00, at: 0)
                onComplete(mergedData,nil)
                
                break
            case .failure(let error):
                onComplete(self.createErrorResponseBuffer(error: error as! NFCReaderError, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
                break
            default:
                // none
                break
            }
        }
        
        self.semaphoreFunctionSignal()
    }
    
    func fastExtendedReadSingleBlock(address: UInt16) -> Data? {
        fastExtendedReadSingleBlock(address:address,onComplete: self.completionHandlerRead)
        return getBufferResponse()
    }
    
    func fastExtendedReadSingleBlock(address: UInt16, onComplete:@escaping handlerResults) {
        self.semaphoreFunctionWait()
        let addressMSB:UInt8 = UInt8((address & 0xFF00) >> 8)
        let addressLSB:UInt8 = UInt8((address & 0x00FF))

        mTag.customCommand(requestFlags: [.highDataRate], customCommandCode: 0xC4, customRequestParameters: Data([addressLSB,addressMSB])){ (response: Data, error: Error?) in
             if let error = error as? NFCReaderError {
                onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
            }else{
                var foo = response
                foo.insert(0x00, at: 0)
                onComplete(Data(foo), nil)
            }
            onComplete(response,nil)
        }
        self.semaphoreFunctionSignal()
    }
    
    func fastExtendedReadMultipleBlocks(range: Range<UInt16>) -> Data? {
        fastExtendedReadMultipleBlocks(range: range,onComplete: self.completionHandlerRead)
        return getBufferResponse()
    }

    
    func fastExtendedReadMultipleBlocks(range: Range<UInt16>, onComplete:@escaping handlerResults) {
        self.semaphoreFunctionWait()
        mTag.extendedFastReadMultipleBlocks(requestFlags:[.address,.highDataRate],blockRange: NSRange(range)) {
            result in
            switch result {
            case .success(let data):
                var mergedData = Data(capacity: data.count*4)
                data.forEach{ cellData in
                    mergedData.append(cellData)
                }
                //mergedData.insert(0x00, at: 0)
                onComplete(mergedData,nil)
                
                break
            case .failure(let error):
                onComplete(self.createErrorResponseBuffer(error: error as! NFCReaderError, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
                break
            default:
                // none
                break
            }
        }
        self.semaphoreFunctionSignal()
    }


    // ST25 DV-I2C CUSTOM Commands : Specific to ST25DV-I2C using Custom Commands
    func readConfiguration(address: UInt8) -> Data? {
        readConfiguration(address: address, onComplete: self.completionHandlerRead)
        return getBufferResponse()
    }
    
    func readConfiguration(address: UInt8, onComplete:@escaping handlerResults) {
        self.semaphoreFunctionWait()
        mTag.customCommand(requestFlags: [.highDataRate], customCommandCode: 0xA0, customRequestParameters: Data([address])){ (response: Data, error: Error?) in
                if let error = error as? NFCReaderError {
                    onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))

                }else{
                    var foo = response
                    foo.insert(0x00, at: 0)
                    //print(foo)
                    onComplete(Data(foo),nil)
                }
                self.semaphoreFunctionSignal()
            }
    }
    
    func writeConfiguration(address: UInt8, data: UInt8) -> Data?  {
        writeConfiguration(address: address, data: data, onComplete:self.completionHandlerWrite)
        return getBufferResponse()
    }
    
    func writeConfiguration(address: UInt8, data: UInt8, onComplete:@escaping handlerResults) {
        self.semaphoreFunctionWait()
        mTag.customCommand(requestFlags: [.highDataRate], customCommandCode: 0xA1, customRequestParameters: Data([address,data])){ (response: Data, error: Error?) in
                if let error = error as? NFCReaderError {
                    onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
                }else{
                    var foo = response
                    foo.insert(0x00, at: 0)
                    onComplete(Data(foo),nil)
                }
                self.semaphoreFunctionSignal()
            }

    }
    
    func readDynConfiguration(address: UInt8) -> Data? {
        readDynConfiguration(address: address, onComplete:self.completionHandlerRead)
        return getBufferResponse()
    }
    
    func readDynConfiguration(address: UInt8, onComplete:@escaping handlerResults) {
        self.semaphoreFunctionWait()
        mTag.customCommand(requestFlags: [.highDataRate], customCommandCode: 0xAD, customRequestParameters: Data([address])){ (response: Data, error: Error?) in
            if let error = error as? NFCReaderError {
                onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
            }else{
                var foo = response
                foo.insert(0x00, at: 0)
                onComplete(Data(foo),nil)
            }
        }
        self.semaphoreFunctionSignal()
    }

    func writeDynConfiguration(address: UInt8, data: UInt8) -> Data? {
        writeDynConfiguration(address: address, data: data, onComplete:self.completionHandlerWrite)
        return getBufferResponse()
    }
    
    func writeDynConfiguration(address: UInt8, data: UInt8, onComplete:@escaping handlerResults) {
        self.semaphoreFunctionWait()
        mTag.customCommand(requestFlags: [.highDataRate], customCommandCode: 0xAE, customRequestParameters: Data([address,data])){ (response: Data, error: Error?) in
                if let error = error as? NFCReaderError {
                    onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
                }else{
                    var foo = response
                    foo.insert(0x00, at: 0)
                    onComplete(Data(foo),nil)
                }
                self.semaphoreFunctionSignal()
            }
    }

    func manageGPO(data: UInt8) -> Data? {
        manageGPO(data: data, onComplete: self.completionHandlerWrite)
        //return getCommandStatus()
        return getBufferResponse()

    }
    
    func manageGPO(data: UInt8, onComplete:@escaping handlerResults) {
        self.semaphoreFunctionWait()
        mTag.customCommand(requestFlags: [.highDataRate], customCommandCode: 0xA9, customRequestParameters: Data([data])){ (response: Data, error: Error?) in
                if let error = error as? NFCReaderError {
                     onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
                 }else{
                    var foo = response
                    foo.insert(0x00, at: 0)
                    onComplete(Data(foo),nil)
                }
                self.semaphoreFunctionSignal()
            }
    }
    
    
    // ISO 15693 WRITE APIs
    
    func writeSingleBlock(startAddress:UInt8, data:Data, onComplete:@escaping handlerResults) {
        self.semaphoreFunctionWait()
        mTag.writeSingleBlock(requestFlags: [.address,.highDataRate], blockNumber: UInt8(startAddress), dataBlock: data){ error in
            if let error = error as? NFCReaderError {
                 onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
             }else{
                 let foo:[UInt8] = [UInt8(0)]
                 onComplete(Data(foo),nil)
             }
            self.semaphoreFunctionSignal()
        }
    }

    func writeSingleBlock(startAddress:UInt8, data:Data) -> Data? {
        writeSingleBlock(startAddress: startAddress, data: data, onComplete: self.completionHandlerWrite)
        return getBufferResponse()
    }
 
    func writeMultipleBlocks(startAddress:UInt8, data:Data) -> Data? {
        writeMultipleBlocks(startAddress:startAddress, data:data, onComplete:self.completionHandlerWrite)
        return getBufferResponse()
    }


    func writeMultipleBlocks(startAddress:UInt8, data:Data, onComplete:@escaping handlerResults){
        self.semaphoreFunctionWait()

        var dataBlock:[Data] = [Data]()
        dataBlock = sliceDataBuffer(data: Data(data), chunckSize: 4)
        let blockRange = NSRange(location: Int(startAddress), length: dataBlock.count)
        mTag.writeMultipleBlocks(requestFlags: [.address,.highDataRate], blockRange: blockRange, dataBlocks: dataBlock)  {
            error in
                if let error = error as? NFCReaderError {
                     onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
                 }else{
                    let foo:[UInt8] = [UInt8(0)]
                    onComplete(Data(foo),nil)
                }
                self.semaphoreFunctionSignal()
            }
    }
    

    func extendedWriteSingleBlock(startAddress:UInt16, data:Data) -> Data? {
        extendedWriteSingleBlock(startAddress:startAddress, data:data,onComplete: self.completionHandlerWrite)
        return getBufferResponse()
    }
    
    func extendedWriteSingleBlock(startAddress:UInt16, data:Data, onComplete:@escaping handlerResults){
        self.semaphoreFunctionWait()
        //print("Write: \(startAddressInt) Size:\(data.count)")
        mTag.extendedWriteSingleBlock(requestFlags: [.address,.highDataRate], blockNumber: Int(startAddress), dataBlock: data){ error in
            if let error = error as? NFCReaderError {
                 onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
             }else{
                 let foo:[UInt8] = [UInt8(0)]
                 onComplete(Data(foo),nil)
             }
            self.semaphoreFunctionSignal()
        }
    }
       
    func extendedlockSingleBlock(address:UInt16) -> Data? {
        extendedlockSingleBlock(address:address, onComplete: self.completionHandlerRead)
        return getBufferResponse()
    }
    
    private func extendedlockSingleBlock(address:UInt16, onComplete:@escaping handlerResults){
        self.semaphoreFunctionWait()
        mTag.extendedLockBlock(requestFlags: [.address,.highDataRate], blockNumber: Int(address)){ error in
            if let error = error as? NFCReaderError {
                 onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
             }else{
                 let foo:[UInt8] = [UInt8(0)]
                 onComplete(Data(foo),nil)
             }
            self.semaphoreFunctionSignal()
        }
    }
    
    
    // Function sendRequest == Transceive
     func sendRequest(requestFlags: Int, commandCode: Int, data: Data) -> Data? {
         self.sendRequest(requestFlags: requestFlags, commandCode: commandCode, data: data,onComplete: self.completionHandlerRead)
         return getBufferResponse()
     }
     
     func sendRequest(requestFlags: Int, commandCode: Int, data: Data,onComplete:@escaping handlerResults) {
         self.semaphoreFunctionWait()
        if #available(iOS 14.0, *) {
            self.mTag.sendRequest(requestFlags: requestFlags, commandCode: commandCode, data: data)
            { result in
                switch result {
                
                case .success(( let responseFlag as NFCISO15693ResponseFlag, let response as Data)):
                    var foo = response
                    foo.insert(responseFlag.rawValue, at: 0)
                    onComplete(Data(foo),nil)
                    break
                case .failure(let error):
                    onComplete(self.createErrorResponseBuffer(error: error as! NFCReaderError, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
                    break
                default:
                    // none
                    break
                }
                self.semaphoreFunctionSignal()
            }
        } else {
            // Fallback on earlier versions
            // Nothing done
        }
     }

    func writeAFI(requestFlags flags: RequestFlag, afi: UInt8) -> Data? {
        self.writeAFI(requestFlags: flags, afi: afi, onComplete: self.completionHandlerRead)
        return getBufferResponse()
    }
    private func writeAFI(requestFlags flags: RequestFlag, afi: UInt8, onComplete:@escaping handlerResults) {
        self.semaphoreFunctionWait()
        self.mTag.writeAFI(requestFlags: flags, afi: afi)
        { error in
            if let error = error as? NFCReaderError {
                onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
            }else{
                let foo:[UInt8] = [UInt8(0)]
                onComplete(Data(foo),nil)

            }
            self.semaphoreFunctionSignal()
        }
    }
    
    func writeDSFID(requestFlags flags: RequestFlag, dsfid: UInt8) -> Data? {
        self.writeDSFID(requestFlags: flags, dsfid: dsfid, onComplete: self.completionHandlerRead)
        return getBufferResponse()
    }
    private func writeDSFID(requestFlags flags: RequestFlag, dsfid: UInt8, onComplete:@escaping handlerResults) {
        self.semaphoreFunctionWait()
        self.mTag.writeDSFID(requestFlags: flags, dsfid: dsfid)
        { error in
            if let error = error as? NFCReaderError {
                onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
            }else{
                let foo:[UInt8] = [UInt8(0)]
                onComplete(Data(foo),nil)

            }
            self.semaphoreFunctionSignal()
        }
    }

    func lockAFI(requestFlags flags: RequestFlag) -> Data? {
        self.lockAFI(requestFlags: flags, onComplete: self.completionHandlerRead)
        return getBufferResponse()
    }
    private func lockAFI(requestFlags flags: RequestFlag, onComplete:@escaping handlerResults) {
        self.semaphoreFunctionWait()
        self.mTag.lockAFI(requestFlags: flags)
        { error in
            if let error = error as? NFCReaderError {
                onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
            }else{
                let foo:[UInt8] = [UInt8(0)]
                onComplete(Data(foo),nil)

            }
            self.semaphoreFunctionSignal()
        }
    }

    func lockDSFID(requestFlags flags: RequestFlag) -> Data? {
        self.lockDSFID(requestFlags: flags, onComplete: self.completionHandlerRead)
        return getBufferResponse()
    }
    private func lockDSFID(requestFlags flags: RequestFlag, onComplete:@escaping handlerResults) {
        self.semaphoreFunctionWait()
        self.mTag.lockDSFID(requestFlags: flags)
        { error in
            if let error = error as? NFCReaderError {
                onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
            }else{
                let foo:[UInt8] = [UInt8(0)]
                onComplete(Data(foo),nil)

            }
            self.semaphoreFunctionSignal()
        }
    }
    func queryNDEF() -> ( ndefStatus:NFCNDEFStatus?, capacity:Int?, error: Error? ) {
        self.queryNDEF(onComplete: self.completionHandlerQueryNdef)
        self.semaphoreBufferSignal()
        return (mNdefStatus,mNdefCapacity,mNdefError)
    }

    func queryNDEF(onComplete:@escaping handlerResultsQueryNdef) {
        self.semaphoreFunctionWait()
        mTag.queryNDEFStatus { ( ndefStatus: NFCNDEFStatus, capacity:Int, error: Error? ) in
            onComplete(ndefStatus,capacity,error)
         }
         self.semaphoreFunctionSignal()
    }
    
    
    private func sliceDataBuffer(data:Data, chunckSize: Int) -> [Data] {
        let length = data.count
        let chunkSize = 4
        var offset = 0
        var dataBlock:[Data] = [Data]()
        
        repeat {
            // get the length of the chunk
            let thisChunkSize = ((length - offset) > chunkSize) ? chunkSize : (length - offset);
            
            // get the chunk
            let blockRange = offset..<(offset + thisChunkSize)
            var chunk = data.subdata(in: blockRange )
            // -----------------------------------------------
            // do something with that chunk of data...
            // -----------------------------------------------
            if chunk.count < chunkSize {
                var byteArray = [UInt8](repeating: 0, count: chunkSize)
                chunk.copyBytes(to: &byteArray, count: chunk.count)
                chunk = Data(byteArray)
            }
            dataBlock.append(chunk)
            
            // update the offset
            offset += thisChunkSize;
            
        } while (offset < length)
        
        print(dataBlock.debugDescription)
        return dataBlock
    }
    
    func printError(error : NFCReaderError)->String {
        var errorString : String = ""
        switch error.code {
            case .ndefReaderSessionErrorTagNotWritable:
                errorString = "ndefReaderSessionErrorTagNotWritable"
                break
            case .ndefReaderSessionErrorTagSizeTooSmall:
                errorString = "ndefReaderSessionErrorTagSizeTooSmall"
                break
            case .ndefReaderSessionErrorTagUpdateFailure:
                    errorString = "ndefReaderSessionErrorTagUpdateFailure"
                break
            case .ndefReaderSessionErrorZeroLengthMessage:
                    errorString = "ndefReaderSessionErrorZeroLengthMessage"
                break
            case .readerErrorInvalidParameter:
                    errorString = "readerErrorInvalidParameter"
                break
            case .readerErrorInvalidParameterLength:
                    errorString = "readerErrorInvalidParameterLength"
                break
            case .readerErrorParameterOutOfBound:
                    errorString = "readerErrorParameterOutOfBound"
                break
            case .readerErrorSecurityViolation:
                    errorString = "readerErrorSecurityViolation"
                break
            case .readerErrorUnsupportedFeature:
                    errorString = "readerErrorUnsupportedFeature"
                break
            case .readerSessionInvalidationErrorFirstNDEFTagRead:
                    errorString = "readerSessionInvalidationErrorFirstNDEFTagRead"
                break
            case .readerSessionInvalidationErrorSessionTerminatedUnexpectedly:
                    errorString = "readerSessionInvalidationErrorSessionTerminatedUnexpectedly"
                break
            case .readerSessionInvalidationErrorSessionTimeout:
                    errorString = "readerSessionInvalidationErrorSessionTimeout"
                break
            case .readerSessionInvalidationErrorSystemIsBusy:
                        errorString = "readerSessionInvalidationErrorSystemIsBusy"
                    break
            case .readerSessionInvalidationErrorUserCanceled:
                        errorString = "readerSessionInvalidationErrorUserCanceled"
                    break
            case .readerTransceiveErrorRetryExceeded:
                        errorString = "readerTransceiveErrorRetryExceeded"
                    break
            case .readerTransceiveErrorSessionInvalidated:
                        errorString = "readerTransceiveErrorSessionInvalidated"
                    break
            case .readerTransceiveErrorTagConnectionLost:
                        errorString = "readerTransceiveErrorTagConnectionLost"
                    break
            case .readerTransceiveErrorTagNotConnected:
                        errorString = "readerTransceiveErrorTagNotConnected"
                    break
            case .readerTransceiveErrorTagResponseError:
                        errorString = "readerTransceiveErrorTagResponseError"
                    break
            case .tagCommandConfigurationErrorInvalidParameters:
                        errorString = "tagCommandConfigurationErrorInvalidParameters"
                    break
            @unknown default:
                        errorString = "Unknown !!!!"
                    break
        }
        return errorString
    }

    private func semaphoreFunctionWait(){
        self.mSemaphoreFunction.wait()
    }
    private func semaphoreFunctionSignal(){
        self.mSemaphoreFunction.signal()
       }
    private func semaphoreBufferWait(){
           self.mSemaphoreBuffer.wait()
       }
    private func semaphoreBufferSignal(){
        self.mSemaphoreBuffer.signal()
    }
}

