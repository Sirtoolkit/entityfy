# Entityfy

Dart code generator that automates the creation of `toEntity()` and `toUiModel()` methods for conversion between domain models, data entities, and UI models.

## 📦 Packages

### `entityfy` (v2.0.0)
Annotation package that provides `@Entityfy` to mark classes that need mapping generation.

### `entityfy_generator` (v2.0.0)
Code generator that processes annotations and automatically creates `toEntity()` and `toUiModel()` methods with class generation.

## 🚀 Installation

Add the packages to your `pubspec.yaml`:

```yaml
dependencies:
  entityfy: ^2.0.0

dev_dependencies:
  entityfy_generator: ^2.0.1
  build_runner: ^2.4.15
```

## 📖 Documentation

- **entityfy**: See [packages/entityfy/README.md](packages/entityfy/README.md) for detailed usage
- **entityfy_generator**: See [packages/entityfy_generator/README.md](packages/entityfy_generator/README.md) for generator details

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
