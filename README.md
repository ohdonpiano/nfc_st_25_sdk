# nfc_st25_flutter_plugin

`nfc_st25_flutter_plugin` is a Flutter plugin that enables interaction with ISO 15693 NFC tags 
using NFC technology on iOS and Android devices. The plugin exposes functions to read blocks, 
present passwords, and start NFC sessions. It's particularly useful for those working with ST25 tags.
Official ST Java and ObjC libraries are included in native code.

## Installation

Add the following line to your pubspec.yaml file to include the library in your project:

dependencies:
nfc_st25_flutter_plugin:
path: ../nfc_st25_flutter_plugin  # Replace with the actual path or published version

Run the following command to update dependencies:

flutter pub get

## Features

This library exposes the following functions in the main Dart file:

### 1. startNfcSession

Starts an NFC session to search for ISO 15693 tags.

#### Example usage:

await NfcSt25.startNfcSession();

### 2. checkNfcAvailability

Checks whether the device supports NFC.

#### Example usage:

bool isAvailable = await NfcSt25.checkNfcAvailability();
print(isAvailable);  // Prints true if NFC is available

### 3. readBlock

Reads a single block of data from an ISO 15693 NFC tag.

#### Parameters:

- int blockNumber: The block number to read.

#### Example usage:

await NfcSt25.readBlock(4);  // Reads block number 4

### 4. readBlocks

Reads multiple blocks of data starting from a specific address.

#### Parameters:

- int address: The starting address.
- int blocks: The number of blocks to read.

#### Example usage:

await NfcSt25.readBlocks(0, 3);  // Reads 3 blocks starting from address 0

### 5. presentPassword

Presents a password to the NFC tag to unlock protected operations.

#### Parameters:

- int passwordNumber: The number of the password to use.
- List<int> password: The password in List<int> format.

#### Example usage:

await NfcSt25.presentPassword(1, [0x12, 0x34, 0x56, 0x78]);  // Presents the password to the tag

## iOS Configuration

To use this library on iOS devices, you need to enable NFC in the iOS project settings. Modify the ios/Runner/Info.plist file to add the NFC usage description:

<key>NFCReaderUsageDescription</key>
<string>This app uses NFC to interact with compatible tags.</string>

## Android Configuration

Ensure that the Android project has NFC permissions. Modify the AndroidManifest.xml file by adding the following permissions:

<uses-permission android:name="android.permission.NFC" />
<uses-feature android:name="android.hardware.nfc" android:required="true" />

## Complete Example

import 'package:nfc_st25_flutter_plugin/nfc_st25.dart';

void main() async {
// Check if NFC is available
bool isAvailable = await NfcSt25.checkNfcAvailability();

if (isAvailable) {
// Start an NFC session
await NfcSt25.startNfcSession();

    // Read a block
    await NfcSt25.readBlock(0);

    // Present a password to the tag
    await NfcSt25.presentPassword(1, [0x12, 0x34, 0x56, 0x78]);
} else {
print("NFC not available on this device");
}
}

## Contributing

If you would like to contribute to improving this library, feel free to open an issue or submit a pull request.

## License

This library is distributed under the MIT License. See the LICENSE file for more details.

