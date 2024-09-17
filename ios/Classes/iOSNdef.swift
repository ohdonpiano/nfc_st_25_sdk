//
//  iOSNdef.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 08/04/2020.
//  Copyright © 2020 STMicroelectronics. All rights reserved.
//

import Foundation
import UIKit
import CoreNFC

@available(iOS 13, *)
class iOSNdef: NSObject {
        
    private var mResponseBuffer:NFCNDEFMessage?
    private var mCommandStatus:TagError?
    
    private var mSemaphoreFunction:DispatchSemaphore = DispatchSemaphore.init(value: 1)
    private var mSemaphoreBuffer:DispatchSemaphore = DispatchSemaphore.init(value: 0)

    typealias handlerResults = (_ responseBuffer : NFCNDEFMessage?, _ tagError: TagError?)->()
    
    private var mTag: NFCNDEFTag!
    private var mSession:NFCNDEFReaderSession!
    
    override init(){
        super.init()
        self.mTag = nil
        //self.mSession = nil
    }

    init(_ tag:NFCNDEFTag){
        super.init()
        self.mTag = tag
        self.mSession = nil
    }
    
    
    init(_ tag:NFCNDEFTag, session:NFCNDEFReaderSession){
           super.init()
           self.mTag = tag
           self.mSession = session
       }
    
    var size:Int!
        
    private func verbose(function : String, ndefMessage : NFCNDEFMessage) {

#if DEBUG
       var myString: NSString?
        myString = "--> \(function) : " as NSString
        NSLog("%@", myString!);
#endif

    }
    
    func sessionInvalidate(){
        self.sessionInvalidate(session: mSession)
    }
    
    func sessionInvalidate(error: TagError?){
        self.sessionInvalidate(session: mSession, error: error)
    }
    
    func sessionInvalidate(session: NFCNDEFReaderSession){
        self.semaphoreFunctionWait()
        session.invalidate()
        self.semaphoreFunctionSignal()
    }
    
    func sessionInvalidate(session: NFCNDEFReaderSession, error: TagError? ){
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

    private func completionHandler(responseRead: NFCNDEFMessage?,error: TagError?) {
        self.mResponseBuffer = responseRead
        self.mCommandStatus = error
        self.semaphoreBufferSignal()
    }
        
    private func extractErrorCode(error :NFCReaderError) -> Int {
        return error.errorCode
    }
    
   // Response Buffer Wait
    private func getBufferResponse() -> NFCNDEFMessage? {
        self.semaphoreBufferWait()
        return self.mResponseBuffer
    }
    
    func readNdef() -> (message:NFCNDEFMessage?,error:String?) {
        self.readNdef(onComplete: self.completionHandler)
        return (getBufferResponse(),self.mCommandStatus?.errorDescription)
    }

    func readNdef(onComplete:@escaping handlerResults) {
        self.semaphoreFunctionWait()
        mTag.readNDEF() { (message: NFCNDEFMessage?, error: Error?) in
            if (error != nil) {
                onComplete(nil,TagError.ResponseError( error!.localizedDescription ))
            }else if (message == nil) {
                onComplete(nil,TagError.ResponseError( "error occurs while retrieving the message"))
            }else{
                self.verbose(function: "\(#function)-\(#line)", ndefMessage: message!)
                onComplete(message,nil)
            }
         }
         self.semaphoreFunctionSignal()
    }

    
    func writeNdef(_ ndefMsg:NFCNDEFMessage) -> String? {
           self.writeNdef(ndefMsg,onComplete: self.completionHandler)
           getBufferResponse()
           return (self.mCommandStatus?.errorDescription)
       }

    func writeNdef(_ ndefMsg:NFCNDEFMessage,onComplete:@escaping handlerResults) {
        self.semaphoreFunctionWait()
        
        self.verbose(function: "\(#function)-\(#line)", ndefMessage: ndefMsg)
        
        mTag.writeNDEF(ndefMsg) { error in
           if error != nil  {
               onComplete(nil,TagError.ResponseError( error!.localizedDescription ))
           }else{
            onComplete(nil,nil)
           }
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

