FLUTTER := flutter

.PHONY: setup gen analyze test integration build-android build-ios format

setup:
$(FLUTTER) pub get

gen:
$(FLUTTER) gen-l10n

analyze:
$(FLUTTER) analyze
dart run dart_code_metrics:metrics analyze lib

format:
dart format lib test integration_test

test:
$(FLUTTER) test --coverage

integration:
$(FLUTTER) test integration_test

build-android:
$(FLUTTER) build apk --debug

build-ios:
$(FLUTTER) build ios --debug --no-codesign
