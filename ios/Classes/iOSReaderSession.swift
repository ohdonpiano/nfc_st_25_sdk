//
//  iOSReaderSession.swift
//  ST25NFCApp
//
//  Created by STMICROELECTRONICS on 10/21/19.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import Foundation
import UIKit
import CoreNFC
import st25sdkFramework

protocol tagReaderSessionViewControllerDelegate:class {
    func handleTag(st25SDKTag: ComStSt25sdkNFCTag, uid: Data!) throws
    func handleTagSessionError(didInvalidateWithError error: Error)
    func handleTagST25SdkError(didInvalidateWithError error: NSException)
}

protocol tagReaderSessionViewControllerDelegateWithFinallyBlock:tagReaderSessionViewControllerDelegate {
    func handleFinallyBlock()
}

protocol ndefReaderSessionViewControllerDelegate:class {
    func handleNdef(tag:iOSNdef,status: NFCNDEFStatus, capacity: Int) throws
    func handleNdefSessionError(didInvalidateWithError error: Error)
    func handleNdefST25SdkError(didInvalidateWithError error: NSException)
}


class iOSReaderSession: NSObject, NFCNDEFReaderSessionDelegate,NFCTagReaderSessionDelegate {
    
    var mtagReaderSessionViewControllerDelegate:tagReaderSessionViewControllerDelegate!
    var mtagReaderSessionViewControllerDelegateWithFinallyBlock:tagReaderSessionViewControllerDelegateWithFinallyBlock!

    var mndefReaderSessionViewControllerDelegate:ndefReaderSessionViewControllerDelegate!

    init(atagReaderSessionViewControllerDelegate:tagReaderSessionViewControllerDelegate){
        super.init()
        self.mtagReaderSessionViewControllerDelegate=atagReaderSessionViewControllerDelegate
    }
    
    init(atagReaderSessionViewControllerDelegate:tagReaderSessionViewControllerDelegateWithFinallyBlock){
        super.init()
        self.mtagReaderSessionViewControllerDelegateWithFinallyBlock=atagReaderSessionViewControllerDelegate
    }


    init(andefReaderSessionViewControllerDelegate:ndefReaderSessionViewControllerDelegate){
        super.init()
        self.mndefReaderSessionViewControllerDelegate=andefReaderSessionViewControllerDelegate
    }

    ////////////////////////////////////////////////////////
    // Reference the NFC session
    private var ndefSession: NFCNDEFReaderSession!
    var tagSession: NFCTagReaderSession!
    
    public var mComStSt25sdkRFReaderInterface:iOSRFReaderInterface!
    
    
    private func initializeNFCTagSession() {
        // Create the NFC Reader Session when the app starts
        self.tagSession = NFCTagReaderSession(pollingOption: [.iso15693,.iso14443], delegate: self, queue: nil)
        self.tagSession?.alertMessage = "Hold your smartphone near an NFC tag"
    }
    
    private func initializeNFCNdefSession() {
        // Create the NFC NDEF Reader Session when the app starts
        self.ndefSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        self.ndefSession?.alertMessage = "Hold your smartphone near an NFC tag"
    }
    ///////////////////////////// NFC CORE DELEGATE /////////////////////////////
    // NFCCore
    func startNdefReaderSession(){
        self.initializeNFCNdefSession()
        self.ndefSession?.begin()
    }
    
    func stopNdefReaderSession(){
        self.ndefSession?.invalidate()
    }
    
    func stopNdefReaderSession(_ msg:String){
        self.ndefSession?.invalidate(errorMessage: msg)
    }

    func startTagReaderSession() {
        self.initializeNFCTagSession()
        self.tagSession?.begin()
    }
    
    func stopTagReaderSession(){
        self.tagSession?.invalidate()
    }
    
    func stopTagReaderSession(_ msg:String){
        self.tagSession?.invalidate(errorMessage: msg)
    }
    
    // NFCNDEFReaderSession Delegate functions
    func tagRemovalDetect(_ tag: NFCNDEFTag) {
        // In the tag removal procedure, you connect to the tag and query for
        // its availability. You restart RF polling when the tag becomes
        // unavailable; otherwise, wait for certain period of time and repeat
        // availability checking.
        self.ndefSession?.connect(to: tag) { (error: Error?) in
            if error != nil || !tag.isAvailable {
                
                self.ndefSession?.restartPolling()
                return
            }
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .milliseconds(500), execute: {
                self.tagRemovalDetect(tag)
            })
        }
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession){
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]){
        if tags.count > 1 {
            session.alertMessage = "More than 1 tags found. Please present only 1 tag."
            self.tagRemovalDetect(tags.first!)
            return
        }
        
        // You connect to the desired tag.
        let tag = tags.first!
        session.connect(to: tag) { (error: Error?) in
            if error != nil {
                session.alertMessage = "Tag No connected"
                session.restartPolling()
                return
            }
            
            // You then query the NDEF status of tag.
            tag.queryNDEFStatus() { (status: NFCNDEFStatus, capacity: Int, error: Error?) in
                if error != nil {
                    session.invalidate(errorMessage: "Fail to determine NDEF status.  Please try again.")
                    return
                }
                  DispatchQueue.global().async {
                     
                    let miOSNdef:iOSNdef = iOSNdef(tag, session: session)

                    // Try/Catch for Exceptions from OBJC calls
                      SwiftTryCatch.try({
                              do {
                                try self.mndefReaderSessionViewControllerDelegate.handleNdef(tag:miOSNdef, status: status, capacity: capacity)
                              } catch {
                              }
                          }
                          , catch: { (error) in
                              if self.mtagReaderSessionViewControllerDelegate != nil {
                                  self.mtagReaderSessionViewControllerDelegate.handleTagST25SdkError(didInvalidateWithError: error)
                              }

                          }
                          , finallyBlock: {
                            self.ndefSession.invalidate()
                          })
                }
            }
        }
    }
   
    
    // NFCTagReaderSessionDelegate Delegate functions
    private func tagRemovalDetect(_ tag: NFCTag) {
        self.tagSession?.connect(to: tag) { (error: Error?) in
            if error != nil || !tag.isAvailable {
      
                self.tagSession?.restartPolling()
                return
            }
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .milliseconds(500), execute: {
                self.tagRemovalDetect(tag)
            })
        }
    }
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
    }

    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        if self.mtagReaderSessionViewControllerDelegate != nil {
            self.mtagReaderSessionViewControllerDelegate.handleTagSessionError(didInvalidateWithError: error)
        }
    
        if self.mtagReaderSessionViewControllerDelegateWithFinallyBlock != nil {
            self.mtagReaderSessionViewControllerDelegateWithFinallyBlock.handleTagSessionError(didInvalidateWithError: error)
        }
 
        
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        if tags.count > 1 {
            session.alertMessage = "More than 1 tags was found. Please present only 1 tag."
            self.tagRemovalDetect(tags.first!)
            return
        }
        
        var mTagUid:Data!
        let mNFCTag:NFCTag = tags.first!
        
        switch tags.first! {
        case let .iso7816(tag):
            mTagUid = tag .asNFCISO7816Tag()!.identifier
        case let .feliCa(tag):
            mTagUid = tag .asNFCFeliCaTag()!.currentIDm
        case let .iso15693(tag):
            mTagUid = tag .asNFCISO15693Tag()!.identifier
        case let .miFare(tag):
            mTagUid = tag .asNFCMiFareTag()!.identifier
        @unknown default:
            session.invalidate(errorMessage: "Tag not valid.")
            return
        }
        
        session.connect(to: tags.first!) { (error: Error?) in
            if error != nil {
                //session.invalidate(errorMessage: "Connection error. Please try again.")
                session.restartPolling()
                return
            }
            
            DispatchQueue.global().async {
               
                self.mComStSt25sdkRFReaderInterface = iOSRFReaderInterface(aNFCTag: mNFCTag,aSession: session)
                
                // Try/Catch for Exceptions from OBJC calls
                SwiftTryCatch.try({
                        do {
                            let tag:ComStSt25sdkNFCTag? = ComStSt25sdkNFCTag.init(comStSt25sdkRFReaderInterface: self.mComStSt25sdkRFReaderInterface)
                            
                            if self.mtagReaderSessionViewControllerDelegate != nil {
                                try self.mtagReaderSessionViewControllerDelegate.handleTag(st25SDKTag: tag!, uid: mTagUid)
                            }else if self.mtagReaderSessionViewControllerDelegateWithFinallyBlock != nil {
                                try self.mtagReaderSessionViewControllerDelegateWithFinallyBlock.handleTag(st25SDKTag: tag!, uid: mTagUid)
                            }else{
                                session.invalidate(errorMessage: "Controller Delegate not existing")
                            }
                        } catch {
                            // Catch something here if not handling throw from ObjC
                        }
                    }
                    , catch: { (error) in
                        if self.mtagReaderSessionViewControllerDelegate != nil {
                                self.mtagReaderSessionViewControllerDelegate.handleTagST25SdkError(didInvalidateWithError: error)
                        }

                    }
                    , finallyBlock: {
                        if self.mtagReaderSessionViewControllerDelegateWithFinallyBlock != nil {
                            self.mtagReaderSessionViewControllerDelegateWithFinallyBlock.handleFinallyBlock()
                        } else {
                            self.mComStSt25sdkRFReaderInterface.sessionInvalidate()
                        }
                       //
                    })
                
          }
        }
    }
}
