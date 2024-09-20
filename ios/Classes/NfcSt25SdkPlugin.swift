import Flutter
import UIKit
import CoreNFC
import st25sdkFramework

public class NfcSt25SdkPlugin: NSObject, FlutterPlugin, NFCTagReaderSessionDelegate, FlutterStreamHandler {
    var session: NFCTagReaderSession?
    var lastTag: iOSIso15693?
    var eventSink: FlutterEventSink?
    var completionHandler: ((Bool) -> Void)?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "nfc_st25", binaryMessenger: registrar.messenger())
        let instance = NfcSt25SdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        let eventChannel = FlutterEventChannel(name: "nfc_st25/tags", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
    
    // Success event
    func eventSuccess(result: Any) {
        DispatchQueue.main.async {
            if let eventSink = self.eventSink {
                // Event stream must be handled on main/ui thread
                eventSink(result)
            }
        }
    }
    
    // Error event
    func eventError(code: String, message: String?, details: Any?) {
        DispatchQueue.main.async {
            if let eventSink = self.eventSink {
                // Event stream must be handled on main/ui thread
                eventSink(FlutterError(code: code, message: message, details: details))
            }
        }
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if lastTag == nil && !["getPlatformVersion", "checkNfcAvailability", "startReading", "stopReading"].contains(call.method) {
            startNfcSession(completion: { [weak self] success in
                if success {
                    self?.handleTag(call, result: result)
                }
            })
        } else {
            handleTag(call, result: result)
        }
    }
    
    func handleTag(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS")
        case "checkNfcAvailability":
            result(true)
        case "startReading":
            startNfcSession(result: result)
        case "stopReading":
            stopNfcSession()
        case "readBlock":
            if let address = call.arguments as? Int {
                readBlock(address: (UInt8(address)), result: result)
            } else {
                print("Wrong input for readBlock")
            }
        case "readBlocks":
            if let args = call.arguments as? [String: Any],
               let address = args["address"] as? Int,
               let blocks = args["blocks"] as? Int {
                readMultipleBlocks(address: address, blocks: blocks, result: result)
            } else {
                print("Wrong input for readBlocks")
            }
        case "extendedReadBlocks":
            if let args = call.arguments as? [String: Any],
               let address = args["address"] as? Int,
               let blocks = args["blocks"] as? Int {
                extendedReadMultipleBlocks(address: address, blocks: blocks, result: result)
            } else {
                print("Wrong input for readBlocks")
            }
        case "presentPassword":
            if let args = call.arguments as? [String: Any],
               let passwordNumber = args["passwordNumber"] as? Int,
               let password = args["password"] as? FlutterStandardTypedData {
                presentPassword(passwordNumber: UInt8(passwordNumber), password: password.data, result: result)
            } else {
                print("Wrong input for presentPassword")
            }
        case "writePassword":
            if let args = call.arguments as? [String: Any],
               let passwordNumber = args["passwordNumber"] as? Int,
               let password = args["password"] as? FlutterStandardTypedData {
                writePassword(passwordNumber: passwordNumber, password: password.data, result: result)
            } else {
                print("Wrong input for writePassword")
            }
        case "writeBlock":
            if let args = call.arguments as? [String: Any],
               let address = args["address"] as? Int,
               let data = args["data"] as? Data {
                writeBlock(address: UInt8(address), data: data, result: result)
            } else {
                print("Wrong input for writeBlock")
            }
        case "writeBlocks":
            if let args = call.arguments as? [String: Any],
               let address = args["address"] as? Int,
               let data = args["data"] as? Data {
                writeMultipleBlocks(address: UInt8(address), data: data, result: result)
            } else {
                print("Wrong input for writeBlocks")
            }
        case "extendedWriteBlocks":
            if let args = call.arguments as? [String: Any],
               let address = args["address"] as? Int,
               let data = args["data"] as? Data {
                extendedWriteMultipleBlocks(address: UInt16(address), data: data, result: result)
            } else {
                print("Wrong input for writeBlocks")
            }
        default:
            result(FlutterMethodNotImplemented)
        }
        if (completionHandler != nil && !["readBlocks"].contains(call.method)) {
            print("session invalidated after command")
            session?.invalidate()
            completionHandler = nil
        }
    }
    
    func startNfcSession(completion: @escaping (Bool) -> Void) {
        completionHandler = completion
        guard NFCTagReaderSession.readingAvailable else {
            completion(false)
            return
        }
        session = NFCTagReaderSession(pollingOption: .iso15693, delegate: self)
        session?.begin()
    }
    
    func startNfcSession(result: @escaping FlutterResult) {
        guard NFCTagReaderSession.readingAvailable else {
            result(FlutterError(code: "NFC_UNAVAILABLE", message: "NFC is not available on this device", details: nil))
            return
        }
        session = NFCTagReaderSession(pollingOption: .iso15693, delegate: self)
        session?.begin()
    }
    
    func stopNfcSession() {
        session?.invalidate()
    }
    
    func getInfo() throws -> [String: Any] {
        guard let tag = lastTag else {
            return [:]
        }
        var tagMap = [String: Any]()
        tagMap["name"] = "ST25DV64K-I"
        tagMap["description"] = "NFC type5 - ISO/IEC 15693"
        tagMap["uid"] = tag.id!.map { String(format: "%02X", $0) }.joined()
        tagMap["memory_size"] = 8192
        let mailBoxInfo = try getMailboxInfo()
        tagMap["mail_box"] = mailBoxInfo
        return tagMap;
    }
    
    /*
    func getInfo() throws -> [String: Any] {
        guard let tag = lastTag else {
            return [:]
        }
        var tagMap = [String: Any]()
        print("calling getSystemInfo ...")
        if let systemInfoData = tag.getSystemInfo() {
                        
            print("got getSystemInfo data: \(systemInfoData)")
            let status = systemInfoData[0]
            let responseLength = systemInfoData[1]
            let uid = systemInfoData.subdata(in: 2..<10)
            
            let dfsid = systemInfoData[10]
            let afi = systemInfoData[11]
            let nbBlock = Int(systemInfoData[12])
            let blockSize = Int(systemInfoData[13])
            let icRef = systemInfoData[14]
                        
            let memorySizeInBytes = nbBlock * blockSize
                        
            tagMap["name"] = "ST25DV64K-I"
            tagMap["description"] = "NFC type5 - ISO/IEC 15693"
            tagMap["uid"] = uid.map { String(format: "%02X", $0) }.joined()
            tagMap["memory_size"] = memorySizeInBytes
            //tagMap["dfsid"] = dfsid
            //tagMap["afi"] = afi
            //tagMap["ic_ref"] = icRef
            
            // Recupero delle informazioni della mailbox
            let mailBoxInfo = try getMailboxInfo()
            tagMap["mail_box"] = mailBoxInfo
            return tagMap;
        } else {
            throw NSError(domain: "NFC", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to read system info"])
        }
    }
     */
    
    func getMailboxInfo() throws -> [String: Bool] {
        var mailBox = [String: Bool]()
        mailBox["mailbox_enabled"] = false //try lastTag.isMailboxEnabled(true)
        mailBox["msg_put_by_controller"] = false // try lastTag.hasHostPutMsg(true)
        mailBox["msg_put_by_nfc"] = false // try lastTag.hasRFPutMsg(true)
        mailBox["msg_miss_by_controller"] = false //try lastTag.hasHostMissMsg(true)
        mailBox["msg_miss_by_nfc"] = false // try lastTag.hasRFMissMsg(true)
        return mailBox
    }
    
    
    func readBlock(address: UInt8, result: @escaping FlutterResult) {
        guard let tag = lastTag else {
            result(FlutterError(code: "NO_TAG", message: "No tag available", details: nil))
            return
        }
        print("readBlock address: \(address)")
        let res = tag.readSingleBlock(address: address)
        result(res)
    }
    
    func readMultipleBlocks(address: Int, blocks: Int, result: @escaping FlutterResult) {
        guard let tag = lastTag else {
            result(FlutterError(code: "NO_TAG", message: "No tag available", details: nil))
            return
        }
        let range = NSRange(location: address, length: blocks)
        print("readMultipleBlocks range: \(range)")
        let res = tag.readMultipleBlocks(range: range)
        if let data = res {
            print("readMultipleBlocks success read: \(data.count) bytes")
        }
        result(res)
    }
    
    func extendedReadMultipleBlocks(address: Int, blocks: Int, result: @escaping FlutterResult) {
        guard let tag = lastTag else {
            result(FlutterError(code: "NO_TAG", message: "No tag available", details: nil))
            return
        }
        let nsRange = NSRange(location: address, length: blocks)
        let range = UInt16(nsRange.lowerBound)..<UInt16(nsRange.upperBound)
        print("extendedReadMultipleBlocks range: \(range)")
        let res = tag.extendedReadMultipleBlocks(range: range)
        if let data = res {
            print("extendedReadMultipleBlocks success read: \(data.count) bytes")
        }
        result(res)
    }
    
    func writeBlock(address: UInt8, data: Data, result: @escaping FlutterResult) {
        guard let tag = lastTag else {
            result(FlutterError(code: "NO_TAG", message: "No tag available", details: nil))
            return
        }
        print("writeBlock address: \(address), data: \(data)")
        let res = tag.writeSingleBlock(startAddress: address, data: data)
        result(res?.isEmpty == false && res?.first == 0)
    }
    
    func writeMultipleBlocks(address: UInt8, data: Data, result: @escaping FlutterResult) {
        guard let tag = lastTag else {
            result(FlutterError(code: "NO_TAG", message: "No tag available", details: nil))
            return
        }
        print("writeMultipleBlocks address: \(address), data: \(data)")
        let res = tag.writeMultipleBlocks(startAddress: address, data: data)
        result(res?.isEmpty == false && res?.first == 0)
    }
    
    func extendedWriteMultipleBlocks(address: UInt16, data: Data, result: @escaping FlutterResult) {
        guard let tag = lastTag else {
            result(FlutterError(code: "NO_TAG", message: "No tag available", details: nil))
            return
        }
        print("extendedWriteMultipleBlocks address: \(address), data: \(data)")
        let res = tag.extendedWriteMultipleBlock(startAddress: address, data: data)
        result(res?.isEmpty == false && res?.first == 0)
    }
    
    func presentPassword(passwordNumber: UInt8, password: Data, result: @escaping FlutterResult) {
        guard let tag = lastTag else {
            result(FlutterError(code: "NO_TAG", message: "No tag available", details: nil))
            return
        }
        print("presentPassword: \(passwordNumber), password: \(password)")
        var data = Data([passwordNumber])
        data.append(password)
        tag.customCommandWithFlags(flags: [.highDataRate], code: 0xB3, data: data) { responseBuffer, tagError in
            if let error = tagError {
                result(FlutterError(code: "PASSWORD_ERROR", message: "Failed to present password", details: error.localizedDescription))
            } else {
                result("Password accepted")
            }
        }
    }
    
    func writePassword(passwordNumber: Int, password: Data, result: @escaping FlutterResult) {
        guard let tag = lastTag else {
            result(FlutterError(code: "NO_TAG", message: "No tag available", details: nil))
            return
        }
        print("writePassword: \(passwordNumber), password: \(password)")
        tag.customCommandWithFlags(flags: [.address, .highDataRate], code: 0xB1, data: password) { responseBuffer, tagError in
            if let error = tagError {
                result(FlutterError(code: "PASSWORD_ERROR", message: "Failed to write password", details: error.localizedDescription))
            } else {
                result("Password written")
            }
        }
    }
    
    public func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("tagReaderSessionDidBecomeActive")
    }
    
    public func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        if let firstTag = tags.first {
            print("tagReaderSession: didDetect: \(firstTag)")
            switch firstTag {
            case .iso15693(let iso15693tag):
                session.connect(to: firstTag) { [weak self] error in
                    if error == nil {
                        print("Tag connected")
                        session.alertMessage = "Tag connesso"
                        self?.lastTag = iOSIso15693(iso15693tag, session: session)
                        if (self?.completionHandler != nil) {
                            print("call completion handler")
                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                                self?.completionHandler!(true)
                            }
                        } else {
                            print("Get info and send tag")
                            do {
                                let tagMap = try self?.getInfo()
                                self?.eventSuccess(result: tagMap!);
                            } catch (let e) {
                                print("Exception: \(e)")
                            }
                        }
                    } else {
                        session.invalidate(errorMessage: "Connection failed")
                    }
                }
            default:
                session.invalidate(errorMessage: "Tag not supported")
            }
        }
    }
    
    public func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print("tagReaderSession: didInvalidateWithError: \(error)")
        lastTag = nil;
        completionHandler = nil;
    }
}
