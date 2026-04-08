# Swifty-Companion

[![Swift 6.0](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2017%2B-blue.svg)](https://developer.apple.com/ios/)
[![Architecture](https://img.shields.io/badge/Architecture-MVVM-green.svg)](#architecture)

Swifty-Companion is a native iOS app built with Swift 6 and SwiftUI for exploring the 42 Network API. It includes OAuth 2.0 authentication, peer search, skill visualization, and project tracking.

## What's New

- Added OAuth 2.0 authentication for secure 42 Intra login.
- Refined the login flow and app configuration.
- Moved simulator screenshots into `Documentation/Images` to keep the repository tidy.
- Updated the README with the latest UI captures and project changes.

## Screenshots

<p align="center">
  <img src="Documentation/Images/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20-%202026-04-08%20at%2018.30.07.png" alt="Swifty-Companion screenshot showing the profile view" width="320" />
  <img src="Documentation/Images/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20-%202026-04-08%20at%2018.30.25.png" alt="Swifty-Companion screenshot showing the search and profile UI" width="320" />
</p>

## Features

- OAuth 2.0 authentication with 42 Intra
- Peer search across the 42 network
- User profile visualization with level, correction points, and wallet
- Dynamic skill bars and project history
- Native SwiftUI UI with dark mode support

## Tech Stack

- Swift 6
- SwiftUI
- URLSession networking
- Keychain for secure token storage
- Kingfisher for profile image loading

## Architecture

This project follows the MVVM pattern for a clean separation of concerns.

```text
View (SwiftUI) <--> ViewModel (State/Logic) <--> Model (API Data)
                         |
                  Network Service (OAuth2)
```
