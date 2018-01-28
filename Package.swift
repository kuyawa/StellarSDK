import PackageDescription

let package = Package(
    name: "StellarSDK",
    dependencies: [
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .exact("0.8.0"))
    ]
)