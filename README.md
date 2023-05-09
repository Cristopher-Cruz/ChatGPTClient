# ChatGPT Client: iOS, macOS, watchOS

This is a cross-platform app that allows users to interact with OpenAI's ChatGPT model on iPhone, Mac, and Apple Watch devices. The app was built using the official ChatGPT API, which is powered by the GPT-3.5 Turbo model and the chat completions endpoint. You can find more information about these technologies in the official [documentation](https://openai.com/blog/introducing-chatgpt-and-whisper-apis).

## SwiftUI

The ChatGPT Client was built using SwiftUI, a modern and intuitive framework that allows developers to build dynamic and interactive user interfaces using a declarative approach. SwiftUI provides a set of common UI components that can be easily adapted to all Apple platforms, taking a more "platform-agnostic" approach as compared to UIKIT. In this project, views and models are shared across the targets (iOS, macOS, watchOS) efficiently, without the need for additional code, setup, or configuration.

## Concurrency

The ChatGPT Client relies heavily on the concurrency features introduced in Swift 5.5. Specifically, the app uses the following components:

- [AsyncStream and AsyncThrowingStream:](https://github.com/apple/swift-evolution/blob/main/proposals/0314-async-stream.md) to retrieve the json response (a stream of asynchronous values or errors) and return it to the display asynchronously.

- [Async/await:](https://github.com/apple/swift-evolution/blob/main/proposals/0296-async-await.md) new pattern for asynchronous programming that greatly increases code readability. 

- [Global Actors:](https://github.com/apple/swift-evolution/blob/main/proposals/0316-global-actors.md) a concurrency mechanism that provides a structured and safe approach to managing concurrent access to shared mutable state. In the scope of this project, @MainActor is a significant feature of this mechanism, used to guarantee that all updates to the UI are executed on the main thread. This ensures smooth and responsive UI interactions, making @MainActor a critical component of the project's architecture.

- [Task](https://github.com/apple/swift-evolution/blob/main/proposals/0304-structured-concurrency.md#tasks) This API provides a structured way to manage and coordinate asynchronous tasks, ensuring that they execute safely and predictably. In this project, Tasks are used for the execution of complex, multi-step operations and for error handling. 


## API Request and JSON Response Handling

The ChatGPT API requires creating a personal API key and following the rules outlined in the documentation to make HTTP requests using the "Bearer" scheme. Since GPT models consume and produce unstructured text as a sequence of "tokens," the API response is returned in JSON format and includes chunked data fields, including the response to a user prompt. To extract the response from the sequence, the ChatGPT client uses Swift's JSONDecoder and stores only the relevant data in custom models, streamlining the data processing.

## Conversation History

To allow ChatGPT to be aware of previous conversation contexts within our client application, we store the previous conversations in an array and include them in the prompt sent in the request. To prevent surplus charges by the API, we implement a function that checks the number of characters in the array, ensuring it does not exceed a hard limit. If the limit is exceeded, the oldest message is removed from the historyList array, and the function is called recursively to generate a new array. Finally, the function returns the resulting array of Message objects. Here's the code for the generateMessages function:
```Swift
private func generateMessages(from text: String) -> [Message] {
    var messages = [systemMessage] + historyList + [Message(role: "user", content: text)]
    
    if messages.contentCount > (4000 * 4) {
        _ = historyList.removeFirst()
        messages = generateMessages(from: text)
    }
    return messages
}
```
