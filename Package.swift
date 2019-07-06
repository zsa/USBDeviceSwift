// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "USBDeviceSwift",
    products: [
        .library(
            name: "USBDeviceSwift",
            targets: ["USBDeviceSwift"]),
    ],
    targets: [
        .target(
            name: "USBDeviceSwift",
            dependencies: [])
    ]
)
