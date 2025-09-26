# Verifying the Downloaded APK

This guide explains how to verify that a downloaded APK was **signed by us** and has **not been tampered with**.  
Verification ensures that the app you install is authentic and safe.

## 1. Downloads

-   [Download the latest APK release](/download/)
-   [Download the public signing certificate (`signing-key.pem`)](https://github.com/RubberDuckCrew/gitdone/tree/main/assets/keys/signing-key.pem)

## 2. Tools Required

To perform the verification, you need:

-   **Java Development Kit (JDK)**: Provides the [`keytool` utility](https://docs.oracle.com/en/java/javase/17/docs/specs/man/keytool.html).

-   **Android SDK Build Tools**: Provides the [`apksigner` utility](https://developer.android.com/studio/command-line/apksigner).

## 3. Verify the APK Signature

Run the following command on the downloaded APK:

```bash
<ANDROID_SDK>/build-tools/<VERSION>/apksigner verify --verbose --print-certs <DOWNLOADED_APK>.apk
```

You will see output similar to:

```text
Verified using v2 scheme (APK Signature Scheme v2): true
Number of signers: 1
Signer #1 certificate SHA-256 digest: d331ca3706ba574eb665212665c9b9d43203202f348ed828ee4652f16a28a13d
```

## 4. Compare the Certificate Fingerprint

Check that the `SHA-256 digest` shown in the output matches the fingerprint of our official certificate.

To calculate the fingerprint of the published certificate (`signing-key.pem`):

```bash
keytool -printcert -file signing-key.pem
```

You should see the same **SHA-256 digest** as in the `apksigner` output.

## 5. Verification Result

-   ✅ If the fingerprints match:  
    The APK was signed with our official private key and is authentic.

-   ❌ If the fingerprints do **not** match:  
    The APK is **not authentic** and should not be installed.

## Notes

-   We currently sign using the **v2 signature scheme**, which is supported on all Android 7.0+ devices.
-   If you need to run the app on older devices (Android 5/6), we also provide APKs signed with both **v1 and v2 schemes**.
-   When installing from the **Google Play Store**, additional signature schemes (v3/v4, SourceStamp) are automatically added by Google Play.
