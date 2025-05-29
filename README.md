# projeto_modelo_20251

Projeto Modelo

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Gerção da lib de conexão HTTP
openapi-generator generate -c config_openapi_generator.yaml

cd collegeapi
flutter pub get
flutter pub run build_runner build


## criação de pacote para reaproveitar funções
```
flutter create -t package confirm_dialog
```

* Para utiilizar