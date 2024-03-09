import SwiftUI
import SDWebImageSwiftUI


struct SpeakerView: View {
    @AppStorage("isLoading") var isLoading: Bool = false
    @State var speakers = [Speaker]()
    
    var body: some View {
        ScrollView (.vertical){
            ForEach(speakers) {speaker in
                LazyVStack(alignment: .leading, spacing: 15) {
                    
                    NavigationLink {
                        SpeakerRetrieveView(speakerId: speaker.id ?? "1", speaker: speaker)
                    } label: {
                        HStack {
                            WebImage(url: URL(string: speaker.photo ?? "")).resizable().scaledToFit()
//                            AsyncImage(url: URL(string: speaker.photo ?? "")) {image in image
//                                    .resizable()
////                                    .scaledToFill()
//                            } placeholder: {
//                                ProgressView()
//                            }
                                .frame(width: 70, height: 70)
                                .clipShape(.circle)
                            VStack(alignment: .leading) {
                                Text(speaker.name! + " " + speaker.surname!)
                                Text(speaker.specialization ?? "")
                                    .font(.system(size: 12))
                                    .multilineTextAlignment(.leading)
                            }
                        }
                    }
                    .padding(.all)
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }

        .task {
            speakers = await Network().getSpeakerList()
        }
    }
}


#Preview {
    SpeakerView()
}
