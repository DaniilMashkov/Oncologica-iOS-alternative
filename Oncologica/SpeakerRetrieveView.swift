import Foundation
import SDWebImageSwiftUI
import SwiftUI


struct SpeakerRetrieveView: View {
    @State var speakerId: String
    @State var speaker: Speaker
    @StateObject var events = EventObj()
    @AppStorage("isLoading") var isLoading: Bool = false
    @Environment(\.dismiss) var dismiss

    @State var expandText = false
    
    
    var body: some View{
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 10) {
                HStack {
                    WebImage(url: URL(string: speaker.photo ?? "")).resizable().scaledToFit()
                    .frame(width: 100, height: 100, alignment: .leading)
                        .clipShape(.circle)
                    
                    VStack {
                        Text(speaker.name ?? "")
                        Text(speaker.surname ?? "")
                        Button {
                            
                        } label: {
                            Image(systemName: "ellipsis.message")
                            Text("Чат")
                                .font(.headline)
                        }
                        .padding(6)
                        .background(.orange.opacity(0.2))
                        .clipShape(Capsule())
                        .foregroundColor(.orange)
                    }
                    .font(.title3)
                }
        
                VStack(alignment: .leading, spacing: 5) {
                    Text("Специализация")
                        .font(.headline)
                    Text(speaker.specialization ?? "")
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Описание")
                        .font(.headline)
                    if speaker.description?.count ?? 0 < 300 {
                        Text(speaker.description ?? "")
                            .font(.caption)
                    } else {
                        Text(speaker.description ?? "")
                            .font(.caption)
                        Button {
                            expandText.toggle()
                        } label: {
                            Text(expandText ? "Cвернуть" : "Ещё...")
                        }
                    }
                }
                .frame(maxHeight: expandText ? .infinity : 200, alignment: .leading)
                .animation(.easeInOut, value: expandText)
            }
            .frame(
                  minWidth: 0,
                  maxWidth: .infinity,
                  minHeight: 0,
                  maxHeight: .infinity,
                  alignment: .topLeading
                )
            .padding(.all)
            EventView(events: events)
        }
        .navigationBarBackButtonHidden()
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem (placement: .principal){
                Text("\(speaker.name ?? "") \(speaker.surname ?? "")")
                    .foregroundStyle(.secondary)
            }
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.secondary)
                }
            }
        }
        .task {
            var data = await Network().getSpeakerWithEvents(speakerId: speakerId)
            speaker = data.0
            events.events = data.1
            print(events.events.first?.place ?? "")
        }
    }
}


#Preview {
    SpeakerRetrieveView(speakerId: "519d2612-a0bb-430d-a729-4657609368a8", speaker: Speaker())
}
