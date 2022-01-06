# flutter-start-app
New Sample Flutter Study App

# Installing Flutter

1. [Download Flutter source](https://docs.flutter.dev/get-started/install/macos)
1. Unzip file
1. Create a folder called Developer at User directory (same as "~"): /Users/username and create Developer folder and move flutter unzipped folder to that
1. Add: ``` export PATH="$PATH:/Users/username/Developer/flutter/bin ``` to:
    1. nano ~/.bash_profile
    1. nano ~/.zshrc
    1. nano ~/.bashrc
    1. nano ~/.profile

# Run Flutter Commands

1. Version: ``` $ flutter --version ```
1. Missing Packages: ``` $ flutter doctor ```

# Installing Missing Itens

## Android

1. Install & Open Android Studio
1. Open Android Studio Preferences > Plugins > Browse Repository > Flutter Plugin : INSTALL IT
1. Now Android Studio shows up the Flutter option for projects

## Visual Code

1. Install Flutter PlugIns
1. --> the emulators are displayed at the bottom on a blue lane


# Create flutter project

1. Create: ``` $ flutter create app_name ```
1. Run: ``` $ cd app_name && flutter run ```

# Running Mobile - Android

1. Emulators (show): ``` $ flutter emulators ```
1. Emulators (run): ``` $ flutter emulators --launch Pixel_3a_API_30 (emulator_id) ``` 
1. Emulators (availables): ``` $ flutter devices ```
1. Running on openned emulator: ``` $ flutter run ```
1. Running on specific emulator: ``` $ flutter run -d emulator-5554 (emulator id) ```
1. Running on chrome: ``` $ flutter run -d chrome ```

# Running Mobile - iOS

1. Run command (if ios simuator not showing): ``` sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer ```
1. On  
1. Spotlight: type "simulator"
1. (second option) terminal type: open -a simulator 