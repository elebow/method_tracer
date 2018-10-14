# Changelog

## 1.0.0

- Accept a second, optional parameter in the initializer so we can short-circuit matching methods based on the class name for performance. This is so useful that the initializer's two arguments are now both keywords, indicating equal importance.
- MethodTracer::Tracer no longer creates TracePoints upon initialization. Use the new `#enable` method to begin tracing.
- Change output format to be even more machine-readable

## 0.2.0

- Rewrite to use Ruby's TracePoint instead of manually unbinding and rebinding methods. This has fewer side effects, but is much slower.

## 0.1.0

- Initial release
