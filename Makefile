.Phony: start deps json

start:
	flutter run

deps:
	flutter pub global activate get_cli
	flutter pub get

json:
	flutter pub run build_runner build 