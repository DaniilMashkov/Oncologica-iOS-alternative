import SwiftUI
import Foundation


struct MainScreenView: View {
    @AppStorage("isLoading") var isLoading: Bool = false
    @StateObject var events = EventObj()
    @State var showingNotifications = false
    
    
    var body: some View {
        TabView {
            NavigationStack {
                EventView(events: events)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading){
                            Text("Ближайшие мероприятия")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                showingNotifications.toggle()
                            } label: {
                                Image(systemName: "bell")
                                    .sheet(isPresented: $showingNotifications) {
                                        NotificationView()
                                    }
                                    .font(.title3)
                                    .overlay(NotificationCountView().position(CGPoint(x: -3.0, y: 35.0)))
                            }
                        }
                    }
            }
            .tabItem {
                Label("", systemImage: "house")
            }
            
            NavigationStack {
                CalendarView()
                    .blur(radius: isLoading ? 5 : 0)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading){
                            Text("Календарь мероприятий")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                        }
                        
                    }
            }
            .tabItem {
                Label("", systemImage: "calendar")
            }
            
            NavigationStack {
                SpeakerView()
                    .blur(radius: isLoading ? 5 : 0)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading){
                            Text("Список ведущих")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                showingNotifications.toggle()
                            } label: {
                                Image(systemName: "bell")
                                    .font(.title3)
                                    .sheet(isPresented: $showingNotifications) {
                                        NotificationView()
                                    }
                                    .font(.title3)
                                    .overlay(NotificationCountView().position(CGPoint(x: -4.0, y: 37.0)))
                            }
                        }
                    }
            }
            .tabItem {
                Label("", systemImage: "person.2.wave.2")
            }
            
            NavigationStack {
                ProfileView()
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading){
                            Text("Профиль")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                showingNotifications.toggle()
                            } label: {
                                Image(systemName: "bell")
                                    .sheet(isPresented: $showingNotifications) {
                                        NotificationView()
                                    }
                                    .font(.title3)
                                    .overlay(NotificationCountView().position(CGPoint(x: -4.0, y: 37.0)))
                            }
                        }
                    }
            }
            .tabItem {
                Label("", systemImage: "person")
            }
        }
        .task {
            await events.events = Network().getComingEvents()
        }
    }
}


#Preview {
    MainScreenView()
}
