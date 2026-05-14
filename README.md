# quiver-moq

Media over QUIC components for Quiver. This package contains the shared MOQ model types plus relay and client building blocks backed by Quiver's QUIC core and stream packages.

## Products

| Product | Purpose |
| --- | --- |
| `MOQCore` | Shared MOQ objects, sessions, tracks, transport-facing models, and core protocol helpers. |
| `MOQRelay` | Relay-side components for accepting and forwarding MOQ objects. |
| `MOQClient` | Client-side components for producing or consuming MOQ sessions. |

## Installation

Add the package to your `Package.swift`:

```swift
dependencies: [
	.package(url: "https://github.com/hironichu/quiver-moq.git", branch: "main")
]
```

Then depend on the products you need:

```swift
.target(
	name: "MyTarget",
	dependencies: [
		.product(name: "MOQCore", package: "quiver-moq"),
		.product(name: "MOQRelay", package: "quiver-moq"),
		.product(name: "MOQClient", package: "quiver-moq"),
	]
)
```

## Local Development

Keep this package next to `quiver-quic`:

```text
quiver-packages/
├── quiver-quic/
└── quiver-moq/
```

Set `QUIVER_PACKAGES_PATH=/path/to/quiver-packages` if your local Quiver package checkouts live somewhere else.

## Dependencies

- `quiver-quic` for `QUICCore` and `QUICStream` types.
- `swift-log` for diagnostics.

## Development Commands

```bash
swift build
swift test
```

## Relationship To Quiver

The root `quiver` package conditionally re-exports MOQ products through the `MOQSupport` package trait.
