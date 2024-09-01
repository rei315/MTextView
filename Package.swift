// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MTextView",
  platforms: [
    .iOS(.v16)
  ],
  products: [
    .library(
      name: "MTextView",
      targets: ["MTextView"]
    ),
  ],
  targets: [
    .target(
      name: "MTextView"),
    .testTarget(
      name: "MTextViewTests",
      dependencies: ["MTextView"]
    ),
  ]
)
