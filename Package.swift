import PackageDescription

let package = Package(
    name: "StellarSDK",
    dependencies: [
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .exact("0.7.0"))  // Swift 3.2
    ]
)
