## 1.0.4

* Updated the Android ST25SDK dependency from 1.11.0 to 1.13.0.
* Updated the Android reader interface to 1.0.12 from the ST25SDK 1.13.0 package.

## 1.0.3

* Fixed `manageGPO` command mapping to match ST25DV semantics (`0x00=SET`, `0x01=RESET`).
* Added support for `0x80` as the canonical `INTERRUPT` value.
* Kept `0x02` as a backward-compatible alias for `INTERRUPT`.
* Updated Android `manageGPO` call to use addressed + high data rate request flags.
* Updated README and example app documentation for the corrected `manageGPO` values.

## 1.0.2

* Added Dart API validation for `writeConfiguration(address, data)` and `manageGPO(data)`.
* Documented `writeConfiguration` and `manageGPO` in README with usage and constraints.
* Added `writeConfiguration` and `manageGPO` controls to the example app.
* Improved example hex parsing for block address input.

## 1.0.1

*   Update Android Gradle plugin to be compatible with modern Flutter versions.
*   Update `pubspec.yaml` with improved description and metadata.
*   Added a standard MIT license file.
