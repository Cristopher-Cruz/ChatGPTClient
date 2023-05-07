# ChatGPT Client: iOS, macOS, watchOS

This is a cross-platform app that allows users to interact with OpenAI's ChatGPT model on iPhone, Mac, and Apple Watch devices. The app was built using the official ChatGPT API, which is powered by the GPT-3.5 Turbo model and the chat completions endpoint. You can find more information about these technologies in the official [documentation](https://openai.com/blog/introducing-chatgpt-and-whisper-apis).

## SwiftUI

The ChatGPT Client was built using SwiftUI, a modern and intuitive framework that allows developers to build dynamic and interactive user interfaces using a declarative approach. SwiftUI provides a set of common UI components that can be easily adapted to all Apple platforms, taking a more "platform-agnostic" approach as compared to UIKIT. In this project, views and models are shared across the targets efficiently, without the need for additional code, setup, or configuration.

## Concurrency

The ChatGPT Client relies heavily on the concurrency features introduced in Swift 5.5. Specifically, the app uses the following components:

- [AsyncStream and AsyncThrowingStream:](https://github.com/apple/swift-evolution/blob/main/proposals/0314-async-stream.md) These APIs are part of the Swift concurrency model and allow developers to generate a stream of asynchronous values or errors. This can be used to asynchronously receive and process data, making it easier to handle large data sets and network requests.
- [Async/await:](https://github.com/apple/swift-evolution/blob/main/proposals/0296-async-await.md) a powerful language feature that allows developers to write asynchronous code in a synchronous and intuitive manner. It is based on the concept of asynchronous functions, which enable the program to execute other tasks while the function is waiting for a result, without blocking the thread. By using the "await" keyword, the execution of the function is paused until the result is available. This feature enables developers to write code that appears synchronous, but actually runs asynchronously. With async/await, code can be more readable and understandable, particularly when dealing with complex and multi-step operations. This feature also allows developers to use a more sequential style of programming, replacing the need for callbacks or completion handlers. As a result, the code is easier to reason about, and the likelihood of bugs is reduced.
- [Global Actors:](https://github.com/apple/swift-evolution/blob/main/proposals/0316-global-actors.md) a concurrency mechanism that provides a structured approach to managing concurrent access to shared mutable state. It defines a set of constraints on how different parts of the program can access and modify shared state, which are enforced at compile time to ensure safe and predictable concurrency. In this context, @MainActor is a significant aspect used in this project, as it designates the actor responsible for managing access to the main thread. This guarantees that all updates to the UI are executed on the main thread, ensuring smooth and responsive user interface interactions.
- [Task](https://github.com/apple/swift-evolution/blob/main/proposals/0304-structured-concurrency.md#tasks) This API provides a structured way to manage and coordinate asynchronous tasks, ensuring that they execute safely and predictably. Tasks are used to define and schedule work that runs concurrently with other tasks, and can be used to coordinate the execution of complex, multi-step operations. Tasks also provide a way to handle and propagate errors that may occur during asynchronous operations.

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