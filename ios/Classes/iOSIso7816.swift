//
//  iOSIso7816.swift
//  ST25ReadRange
//
//  Created by STMICROELECTRONICS on 20/04/2021.
//  Copyright © 2021 STMicroelectronics. All rights reserved.
//

import Foundation
import UIKit
import CoreNFC



@available(iOS 13, *)
class iOSIso7816: NSObject {
        
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
    
    private var mTag: NFCISO7816Tag!
    private var mSession:NFCTagReaderSession!
    
    override init(){
        super.init()
        self.mTag = nil
    }

    init(_ tag:NFCISO7816Tag){
        super.init()
        self.mTag = tag
        self.mSession = nil
    }
    
    
    init(_ tag:NFCISO7816Tag, session:NFCTagReaderSession){
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
            let tagErrorValue = self.extractIso7816ErrorCode(error :error)
            let foo:[UInt8] = [0x01,UInt8(tagErrorValue)]
            self.printBuffer(function: debugCodeLocationInformation, buffer: Data(foo))
            return (Data(foo))
    }
    
    private func extractIso7816ErrorCode(error :NFCReaderError) -> Int {
        var errorValue: Int = 0x0F
        if let  errorDictionnary: Dictionary<String, AnyObject> =  error.errorUserInfo as? Dictionary<String, AnyObject> {
            if errorDictionnary["ISO15693TagResponseErrorCode"] != nil {
                errorValue = errorDictionnary["ISO15693TagResponseErrorCode"] as! Int
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
        return self.mCommandStatus
   }
    private func getBufferResponseWithStatus() -> responseWithError? {
        self.semaphoreBufferWait()
        return responseWithError.init(response: self.mResponseBuffer!, error: self.mCommandStatus!)
   }
    
    
    // sendISO7816Command
    func sendISO7816Command(_ data: Data) -> Data? {
       let nfc7816Apdu:NFCISO7816APDU = NFCISO7816APDU.init(data: data)!
       self.sendISO7816Command(nfc7816Apdu,onComplete: self.completionHandlerRead)
       return getBufferResponse()
    }

     func sendISO7816Command(_ apdu: NFCISO7816APDU) -> Data? {
        self.sendISO7816Command(apdu,onComplete: self.completionHandlerRead)
        return getBufferResponse()
     }
     
     func sendISO7816Command(_ apdu: NFCISO7816APDU, onComplete:@escaping handlerResults) {
         self.semaphoreFunctionWait()
        self.mTag.sendCommand(apdu: apdu)
          { response,sw1,sw2, error in
                 if let error = error as? NFCReaderError {
                     onComplete(self.createErrorResponseBuffer(error: error, debugCodeLocationInformation: "\(#function)-\(#line)"),TagError.ResponseError( error.localizedDescription ))
                 }else{
                     var foo = response
                     foo.append(sw1)
                     foo.append(sw2)
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


