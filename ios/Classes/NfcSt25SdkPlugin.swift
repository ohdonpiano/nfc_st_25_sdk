import Flutter
import UIKit
import CoreNFC
import st25sdkFramework

public class NfcSt25SdkPlugin: NSObject, FlutterPlugin, NFCTagReaderSessionDelegate, FlutterStreamHandler {
    var session: NFCTagReaderSession?
    var currentTag: NFCISO15693Tag?
    var eventSink: FlutterEventSink?

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

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "checkNfcAvailability":
            result(true)
        case "startNfcSession":
            startNfcSession(result: result)
        case "readBlock":
            if let address = call.arguments as? Int {
                readBlock(address: address, result: result)
            }
        case "readBlocks":
            if let args = call.arguments as? [String: Any],
               let address = args["address"] as? Int,
               let blocks = args["blocks"] as? Int {
                readMultipleBlocks(address: address, blocks: blocks, result: result)
          }
        case "presentPassword":
            if let args = call.arguments as? [String: Any],
               let passwordNumber = args["passwordNumber"] as? Int,
               let password = args["password"] as? [Int] {
                presentPassword(passwordNumber: passwordNumber, password: password, result: result)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func startNfcSession(result: @escaping FlutterResult) {
        guard NFCTagReaderSession.readingAvailable else {
            result(FlutterError(code: "NFC_UNAVAILABLE", message: "NFC is not available on this device", details: nil))
            return
        }
        session = NFCTagReaderSession(pollingOption: .iso15693, delegate: self)
        session?.begin()
    }

    func readBlock(address: Int, result: @escaping FlutterResult) {
        guard let tag = currentTag else {
            result(FlutterError(code: "NO_TAG", message: "No tag available", details: nil))
            return
        }
        tag.readSingleBlock(requestFlags: .highDataRate, blockNumber: UInt8(address)) { data, error in
            if let error = error {
                result(FlutterError(code: "READ_ERROR", message: "Failed to read block", details: error.localizedDescription))
            } else {
                result(data)
            }
        }
    }

    func readMultipleBlocks(address: Int, blocks: Int, result: @escaping FlutterResult) {
            guard let tag = currentTag else {
                result(FlutterError(code: "NO_TAG", message: "No tag available", details: nil))
                return
            }
            let range = NSRange(location: address, length: blocks)
            tag.readMultipleBlocks(requestFlags: .highDataRate, blockRange: range) { data, error in
                if let error = error {
                    result(FlutterError(code: "READ_ERROR", message: "Failed to read block", details: error.localizedDescription))
                } else {
                    result(data)
                }
            }
        }

    func presentPassword(passwordNumber: Int, password: [Int], result: @escaping FlutterResult) {
        guard let tag = currentTag else {
            result(FlutterError(code: "NO_TAG", message: "No tag available", details: nil))
            return
        }
        let passwordData = Data(password.map { UInt8($0) })
        tag.customCommand(requestFlags: [], customCommandCode: 0xB3, customRequestParameters: passwordData) { response, error in
            if let error = error {
                result(FlutterError(code: "PASSWORD_ERROR", message: "Failed to present password", details: error.localizedDescription))
            } else {
                result("Password accepted")
            }
        }
    }

    public func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
    }

    public func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        if let firstTag = tags.first {
            switch firstTag {
            case let .iso15693(tag):
                session.connect(to: firstTag) { [weak self] error in
                    if error == nil {
                        self?.currentTag = tag
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
        session.invalidate()
    }
}
