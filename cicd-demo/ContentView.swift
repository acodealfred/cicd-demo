import SwiftUI
import Playgrounds

struct ContentView: View {
    var body: some View {
        Text(Greeting.message(for: nil))
            .padding()
    }
}

#Preview {
    ContentView()
}

#Playground {
    _ = 1 + 2
}
