# EnclaveTalk

**A private, on-device AI chat application built with Flutter.**

EnclaveTalk is a privacy-focused conversational AI that runs entirely on your device. All models, data, and chat history are stored locally, ensuring that your conversations remain secure and offline.

## ✨ Features

-   **100% On-Device:** No cloud servers, no data collection. Your data never leaves your device.
-   **Privacy First:** Designed from the ground up to be a secure enclave for your conversations and knowledge.
-   **Customizable Appearance:** Switch between light and dark themes and choose from a variety of accent colors to personalize your experience.
-   **Local Model Management:** (In-progress) A dedicated screen to download, manage, and switch between different on-device language models.
-   **Chat History:** (In-progress) All chat sessions are saved locally for you to review later.
-   **Persistent Settings:** Your theme and appearance choices are saved locally and remembered every time you open the app.

## 🛠️ Tech Stack

-   **Framework:** Flutter
-   **State Management:** Provider
-   **Local Storage:** SharedPreferences
-   **Planned AI Core:** `flutter_gemma` for on-device LLM inference and embeddings.

## 🚀 Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

-   You must have the Flutter SDK installed. For instructions, view the [online documentation](https://docs.flutter.dev/).

### Installation

1.  **Clone the repo**
    ```sh
    git clone https://github.com/tibssy/enclavetalk.git
    ```
2.  **Navigate to the project directory**
    ```sh
    cd enclavetalk
    ```
3.  **Install dependencies**
    ```sh
    flutter pub get
    ```
4.  **Run the app**
    ```sh
    flutter run
    ```

## 🚧 Project Status

This project is currently under active development. The core UI and state management are in place, with the on-device AI integration being the next major milestone.
