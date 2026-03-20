# Swifty-Companion
A native iOS application built with Swift 6 and SwiftUI to interact with the 42 Network API. Featuring OAuth2 authentication, real-time peer searching, and dynamic progress visualization.

# 42 Swifty-Companion 📱
[![Swift 6.0](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2017%2B-blue.svg)](https://developer.apple.com/ios/)
[![Architecture](https://img.shields.io/badge/Architecture-MVVM-green.svg)](#architecture)

An elegant iOS application built to navigate the 42 Network ecosystem. This app allows users to search for peers, visualize their progress, and track skill evolution using the 42 OAuth2 API.

---

## 🚀 Features
* **OAuth2 Authentication:** Secure login flow integrated with the 42 Intra.
* **Peer Search:** Real-time search functionality for any student in the network.
* **Profile Visualization:** * User info (Level, Correction Points, Wallet).
    * Dynamic Skill Bars (Radar charts/Progress bars).
    * Project History with status filtering (Success/Failure/In Progress).
* **Dark Mode Support:** Native SwiftUI implementation for a sleek look.

---

## 🛠 Tech Stack & Architecture
This project follows the **MVVM (Model-View-ViewModel)** pattern to ensure a clean separation of concerns and testability.

* **Language:** Swift 6 (Strict Concurrency enabled)
* **UI Framework:** SwiftUI
* **Networking:** URLSession (Native) or [Alamofire]
* **Image Caching:** [Kingfisher] (for optimized profile picture loading)
* **Local Storage:** Keychain (for secure Token management)

### Architecture Diagram
```text
View (SwiftUI) <--> ViewModel (State/Logic) <--> Model (API Data)
                          |
                   Network Service (OAuth2)
