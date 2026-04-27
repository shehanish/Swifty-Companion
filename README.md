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

## Application Steps & Screenshots

### Step 1: Authentication
Securely log in to the app using your 42 Intra credentials. The OAuth 2.0 flow ensures your data is protected.
<p align="center">
  <img src="Documentation/Images/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20-%201.png" width="250" />
  <img src="Documentation/Images/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20-%202.png" width="250" />
</p>

### Step 2: Peer Search & Dashboard
Once logged in, search the 42 network for specific peers to view their profile, level, and accomplishments.
<p align="center">
  <img src="Documentation/Images/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20-%203.png" width="250" />
  <img src="Documentation/Images/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20-%204.png" width="250" />
</p>

### Step 3: Detailed Profile (Info, Projects, Skills)
Explore the detailed profile view containing three tabs:
- **Info:** Wallet, correction points, level, and contact details.
- **Projects:** List of completed projects and their final marks.
- **Skills:** Detailed visual breakdown of skill levels.
<p align="center">
  <img src="Documentation/Images/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20-%205.png" width="190" />
  <img src="Documentation/Images/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20-%206.png" width="190" />
  <img src="Documentation/Images/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20-%207.png" width="190" />
</p>

## Project Overview

Swifty-Companion serves as an on-the-go utility designed specifically for students and alumni of the [42 Network](https://42.fr/en/homepage/). The project was created to provide a fast, native, and nicely designed iOS alternative to the web-based Intranet. 

By integrating directly with the official 42 API, the app allows users to seamlessly retrieve their own statistics or search for peers. It breaks down complex data like ongoing and completed projects, curriculum levels, correction points, wallet balances, and overall skill progression over time into easy-to-read, digestible views. The application emphasizes clean architecture, robust state management, and modern design principles using native iOS tools.

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
