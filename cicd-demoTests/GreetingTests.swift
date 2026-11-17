import Testing
@testable import cicd_demo

struct GreetingTests {

    @Test("Greeting falls back to world for missing names and trims real ones", arguments: [
        (nil, "Hello, world!"),
        ("", "Hello, world!"),
        ("   ", "Hello, world!"),
        ("  Ada ", "Hello, Ada!"),
    ] as [(String?, String)])
    func message(name: String?, expected: String) {
        #expect(Greeting.message(for: name) == expected)
    }
}
