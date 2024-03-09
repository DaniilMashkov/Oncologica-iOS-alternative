import Foundation
import SDWebImageSwiftUI
import SwiftUI


class EventObj: ObservableObject {
    @Published var events = [Event]()
}


struct EventView: View {
    @StateObject var events = EventObj()
    @AppStorage("isLoading") var isLoading: Bool = false
    @State var images: [String : String] = [:]
    
    
    var body: some View {
        ScrollView (.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(events.events, id: \.id) { event in
                    NavigationLink {
                        EventRetrieveView(eventId: event.id)
                            .toolbar {
                                ToolbarItem {
                                    Button {
                                        
                                    }label: {
                                        Image(systemName: "calendar.badge.plus")
                                    }
                                    .font(.title3)
                                }
                            }
                    }label:{
                        VStack(alignment: .leading, spacing: 20) {
                            HStack{
                                Text(event.category?.title ?? "")
                                    .font(.system(size: 13))
                                    .padding(8)
                                    .background(.clear.filterButton(text: event.category?.title ?? "") .opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                                    .foregroundColor(Color.init(hex:event.category?.theme?.font ?? ""))
                                Text(event.place ?? event.venue?.venue ?? "")
                                    .font(.system(size: 13))
                                    .padding(8)
                                    .background(.gray .opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                                    .foregroundColor(.gray)
                                
                            }
                            
                            Text(event.heading ?? "")
                                .frame(maxWidth: 300, alignment: .leading)
                                .font(.system(size: 16))
                            
                            if event.banner != nil {
                                WebImage(url: URL(string: event.banner!)).resizable().scaledToFit()
                            }
                            
                            HStack(spacing: 20) {
                                Text(event.formattedTime)
                                Text(event.duration ?? "")
                                    .foregroundStyle(.secondary)
                            }
                            HStack {
                                ForEach(event.speaker?.prefix(2) ?? [], id: \.id) { person in
                                    HStack {
                                        WebImage(url: URL(string: person.photo ?? "")).resizable().scaledToFit()
                                        
                                            .frame(width: 50, height: 50)
                                            .clipShape(.circle)
                                        VStack {
                                            Text(person.name!)
                                            Text(person.surname!)
                                        }
                                        .font(.system(size: 12))
                                    }
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                
                            HStack {
                                if event.speaker?.count ?? 0 > 2 {
                                    Image(systemName: "person")
                                    
                                    let word = "спикер"
                                    let count = String(event.speaker?.count ?? 0 - 2)
                                    
                                    if count.suffix(1) == "1" &&  count.suffix(1) != "11"{
                                        Text("Ещё \(count + " " + word)")
                                    }
                                    if ["2", "3", "4"].contains(count.suffix(1)) && !["12", "13", "14"].contains( count.suffix(1)) {
                                        Text("Ещё \(count + " " + word)а")
                                    } else {
                                        Text("Ещё \(count + " " + word)ов")
                                    }
                                }
                            }
                            .foregroundStyle(.secondary)
                            .font(.system(size: 14))
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 25).fill(.gray).opacity(0.1))
                    }
                }
            }
        }
        .padding(.top)
        .buttonStyle(PlainButtonStyle())
    }
}


#Preview {
    EventView()
}
