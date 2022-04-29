# api-playground-flutter

A basic app to showcase the workings of a Flutter app as a client-side API consumer.


## First run

- Navigate to the desired project and run `flutter create .`
- Run `flutter run` in the project folder.


## Running on iOS

- Build the app
  - `flutter build ios`
    - Ensure bundle identifier is correct (e.g. `arcanemachine-gmail.com`)
      - Open `xCode` -> Left Window -> `Runner` -> General -> Bundle Identifier
- Run the app
  - `flutter run --release -d [device name]`
