import SwiftUI


struct ContentView: View {
    @AppStorage("isLogged") private var isLogged: Bool = false
    @AppStorage("isLoading") var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            if isLogged {
                MainScreenView()
            } else {
                AuthView()
            }
            ProgressView()
                .controlSize(.extraLarge)
                .opacity(isLoading ? 1 : 0)
        }
        .disabled(isLoading)
        .task {
            await Network().getAcceessToken()
        }
        .tint(.orange)
    }
}

#Preview {
    ContentView()
}

