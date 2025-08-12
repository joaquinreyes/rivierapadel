fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Android

### android test

```sh
[bundle exec] fastlane android test
```

Runs all the tests

### android beta

```sh
[bundle exec] fastlane android beta
```

Submit a new Beta Build to Crashlytics Beta

### android deploy

```sh
[bundle exec] fastlane android deploy
```

Deploy a new version to the Google Play

### android release_apk

```sh
[bundle exec] fastlane android release_apk
```

Generate a release APK only

### android build_and_deploy_web

```sh
[bundle exec] fastlane android build_and_deploy_web
```

Build Flutter Web and Deploy to Firebase Hosting

### android build_and_deploy_ios

```sh
[bundle exec] fastlane android build_and_deploy_ios
```

Build and Deploy iOS to testflight

### android build_and_deploy_ios_release

```sh
[bundle exec] fastlane android build_and_deploy_ios_release
```



### android build_appbundle

```sh
[bundle exec] fastlane android build_appbundle
```

Build Android App Bundle

### android build_all_beta

```sh
[bundle exec] fastlane android build_all_beta
```

Build all the things

### android build_all_release

```sh
[bundle exec] fastlane android build_all_release
```

Build all Release

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
