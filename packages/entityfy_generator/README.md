# Entityfy Generator

Code generator for the [`entityfy`](../entityfy) package. Automatically generates `toEntity()` methods for classes annotated with `@EntityMapper`.

## Installation

```yaml
dev_dependencies:
  entityfy_generator: ^1.0.0
  build_runner: ^2.5.4
```

## Features

- **Nested Model Support**: Automatically calls `toEntity()` on nested models
- **Type-Safe Mapping**: Maps based on constructor parameters
- **Multiple Models**: Handles multiple annotated classes in the same file
