import Foundation
import SwiftUI


struct NotificationView: View {
    @AppStorage("isLoading") var isLoading: Bool = false
    @AppStorage("accessToken") private var accessToken = " "
    @State var notifications = [Notification]()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button("Закрыть") {
            dismiss()
        }
        .padding()
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .topTrailing)
        
        ScrollView (.vertical){
            ForEach(notifications, id: \.id) { notification in
                LazyVStack {
                    HStack {
                        Image(systemName: "exclamationmark.bubble.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                        VStack (alignment: .leading) {
                            Text(notification.datetime_str ?? "")
                                .foregroundStyle(.secondary)
                                .font(.system(size: 13))
                            Text(notification.text ?? "")
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 15))
                        }
                    }
                    .tint(.primary)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                }
                
            }
            .padding()
        }
        .task {
            notifications = await Network().getNotifications()
        }
    }
}


#Preview {
    NotificationView(notifications: [Notification]())
}
