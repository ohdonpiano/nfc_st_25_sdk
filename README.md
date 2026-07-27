# nfc_st_25_sdk

Flutter plugin for STMicroelectronics ST25 tags (ISO/IEC 15693) on Android and iOS.

It exposes high-level APIs to:

- detect/read tags
- read/write memory blocks
- present/write passwords
- manage mailbox and NDEF
- write configuration registers and issue GPO commands

## Installation

```yaml
dependencies:
  nfc_st_25_sdk: ^1.0.2
```

Then run:

```bash
flutter pub get
```

## Main API

### Session and availability

```dart
final available = await NfcSt25Sdk.nfcAvailability;
final sub = NfcSt25Sdk.startReading().listen((tag) {
  print('Tag UID: ${tag.uid}');
});
```

### Memory operations

```dart
final block = await NfcSt25Sdk.readBlock(0x00);
final blocks = await NfcSt25Sdk.readBlocks(0x00, 4);
await NfcSt25Sdk.writeBlock(0x00, [0x01, 0x02, 0x03, 0x04]);
```

### New: writeConfiguration

Writes one configuration register on the tag.

```dart
await NfcSt25Sdk.writeConfiguration(0x00, 0x01);
```

- `address`: register address (`0x00..0xFF`)
- `data`: register value (`0x00..0xFF`)

### New: manageGPO

Issues a GPO command.

```dart
await NfcSt25Sdk.manageGPO(0x01);
```

Supported values:

- `0x00`: SET (force GPO low)
- `0x01`: RESET (force GPO high)
- `0x80`: INTERRUPT
- `0x02`: legacy alias for INTERRUPT (kept for backward compatibility)

## iOS configuration

Add in your app `Info.plist`:

```xml
<key>NFCReaderUsageDescription</key>
<string>This app uses NFC to interact with compatible tags.</string>
```

## Android configuration

Ensure your app manifest includes:

```xml
<uses-permission android:name="android.permission.NFC" />
<uses-feature android:name="android.hardware.nfc" android:required="true" />
```

## Example app

The `example/` app includes buttons and fields for:

- `writeConfiguration`
- `manageGPO`

so you can test the new feature on real hardware.
