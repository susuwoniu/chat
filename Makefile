.Phony: start deps json get
local:
	flutter run --dart-define=env=local
start:
	flutter run
prod:
	flutter run --dart-define=env=prod
deps:
	flutter pub global activate get_cli
	flutter pub get

json:
	flutter pub run build_runner build --delete-conflicting-outputs

get:
	flutter pub get
