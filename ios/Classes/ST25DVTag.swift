//
//  ST25DVTag.swift
//  NFCTap
//
//  Created by STMICROELECTRONICS on 29/10/2019.
//  Copyright © 2019 STMicroelectronics. All rights reserved.
//

import Foundation
import UIKit
import CoreNFC
import st25sdkFramework

class ST25DVTag: ComStSt25sdkType5St25dvST25DVTag {
    
    var mComStSt25sdkRFReaderInterface:iOSRFReaderInterface!
    
    
    init(RFReaderInterface:iOSRFReaderInterface,uid:Data) {
        super.init(comStSt25sdkRFReaderInterface: RFReaderInterface, with: IOSByteArray.init(nsData: uid))
        mComStSt25sdkRFReaderInterface = RFReaderInterface
    }
    
    func readCCFile() -> Data! {
        return(readCCFile()?.toNSData())!
    }
}
