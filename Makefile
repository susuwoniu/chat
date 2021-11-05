.Phony: start deps json get

start:
	flutter run

deps:
	flutter pub global activate get_cli
	flutter pub get

json:
	flutter pub run build_runner build

get:
	flutter pub get
