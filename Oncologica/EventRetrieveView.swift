import Foundation
import SDWebImageSwiftUI
import SwiftUI


struct EventRetrieveView: View {
    @State var eventId: String?
    @State var event = Event()
    @State var expandText = false
    @State var showMapsSheet = false
    @State var usersEventStatus = UsersEventStatus()
    
    var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
    var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                if event.online == false {
                    WebImage(url: URL(string: event.banner!))
                        .resizable()
                        .scaledToFit()
                        .padding(-20)
                    Spacer()
                }
                HStack {
                    Text(event.category?.title ?? "")
                        .font(.system(size: 13))
                        .padding(8)
                        .background(Color.init(hex:event.category?.theme?.font ?? "").opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                        .foregroundColor(Color.init(hex:event.category?.theme?.font ?? ""))
                    Text(event.place ?? "")
                        .font(.system(size: 13))
                        .padding(8)
                        .background(.gray .opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                        .foregroundColor(.gray)
                }
                
                Text("\(event.heading ?? "")\n\(event.title ?? "")")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 16))
                
                VStack(alignment: .leading, spacing: 11) {
                    HStack {
                        Text(event.localizedDate().toString("d MMMM") )
                        Text(event.localizedDate().toString("y") )
                            .foregroundStyle(.secondary)
                            .font(.system(size: 14))
                        Text(event.localizedDate().toString("HH:mm") )
                        Text(event.duration ?? "")
                    }
                    
                    Text("Часовой пояс \(localTimeZoneAbbreviation) \(localTimeZoneIdentifier)")
                        .foregroundStyle(.secondary)
                        .font(.system(size: 12))
                }
                
                if event.online ?? false {
                    Link(destination: URL(string: event.venue_online ?? "")!) {
                        Text("\(event.category?.title ?? "") \(Image(systemName: "arrow.right"))")
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).stroke(.orange)
                            )
                    }
                    .background(.orange)
                    .cornerRadius(25)
                    
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Описание")
                        .font(.headline)
                    if event.description?.count ?? 0 < 400 {
                        Text(event.description ?? "")
                            .font(.caption)
                    } else {
                        Text(event.description ?? "")
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
                
                if event.online ?? false {
                    VStack(alignment: .leading) {
                        Text("Спикеры")
                            .font(.headline)
                        ForEach(event.speaker?.prefix(2) ?? [], id: \.id) { person in
                            HStack {
                                WebImage(url: URL(string: person.photo ?? "")).resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .clipShape(.circle)
                                
                                VStack(alignment: .leading) {
                                    Text("\(person.name!) \(person.surname!)")
                                        .font(.system(size: 16))
                                    Text(person.specialization!)
                                        .foregroundStyle(.secondary)
                                        .font(.system(size: 15))
                                }
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
                    
                    if event.reserve_end_time ?? "" >= Date.now.description {
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Придёте?")
                                .font(.headline)
                            HStack(spacing:20) {
                                Button{
                                    Task {
                                        usersEventStatus = await Network().getUsersEventStatus(eventId: event.id ?? "")
                                    }
                                }label: {
                                    usersEventStatus.status == "recorded" ?
                                    Text("\(Image(systemName: "checkmark")) Запись подтверждена")
                                        .frame(width: 220, height: 30)
                                        .background(.green).opacity(0.7)
                                        .foregroundStyle(.white)
                                    :
                                    Text("Да")
                                        .frame(width: 80, height: 30)
                                        .background(.gray).opacity(0.3)
                                        .foregroundStyle(.primary)
                                }
                                .cornerRadius(25)
                                
                                Button{
                                    Task {
                                        usersEventStatus = await Network().discardUsersEventStatus(eventId: event.id ?? "")
                                    }
                                }label: {
                                    usersEventStatus.status == "not_going" ?
                                    Text("\(Image(systemName: "xmark")) Не пойду")
                                        .frame(width: 130, height: 30)
                                        .background(.red).opacity(0.8)
                                    
                                        .foregroundStyle(.white)
                                    :
                                    Text("Нет")
                                        .frame(width: 80, height: 30)
                                        .background(.gray).opacity(0.3)
                                        .foregroundStyle(.primary)
                                }
                                .cornerRadius(25)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    } else {
                        Text("Запись на мероприятие завершена")
                            .foregroundStyle(.red)
                            .font(.system(size: 15))
                    }
                    
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Адрес")
                            .font(.headline)
                        Text(event.address_offline?.address ?? "")
                            .font(.system(size: 13))
                        Button("\(Image(systemName: "arrow.right")) Построить маршрут") {
                            showMapsSheet.toggle()
                        }
                        .frame(maxWidth: .infinity, minHeight: 20)
                        .padding(8)
                        .background(.orange.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                        .foregroundColor(.orange)
                        .sheet(isPresented: $showMapsSheet) {
                            MapsLinksView()
                                .presentationDetents([.fraction(0.3)])
                        }
                    }
                    if event.reserve_end_time ?? "" >= Date.now.description {
                        if event.entry_status?.available_seats ?? 0 > 0 {
                            if ["not_found", "not_going"].contains(usersEventStatus.status) {
                                VStack(alignment: .leading, spacing: 13) {
                                    Text("Запись на мероприятие")
                                        .font(.headline)
                                    
                                    ProgressView(value: Float(event.entry_status?.recorded ?? 0), total: Float(event.entry_status?.available_seats ?? 0), label: {
                                        HStack {
                                            Text(String(event.entry_status?.recorded ?? 0))
                                            Text("Свободных мест:  \(event.entry_status?.available_seats ?? 0)")
                                                .fixedSize()
                                                .foregroundStyle(.green)
                                                .frame(maxWidth: .infinity, alignment: .center)
                                            Text(String(event.number_of_participants ?? 0))
                                        }
                                        .font(.system(size: 14))
                                    }).tint(.green)
                                    
                                    Button("Записаться") {
                                        Task {
                                            usersEventStatus = await Network().getUsersEventStatus(eventId: event.id ?? "")
                                        }
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 20)
                                    .padding(8)
                                    .background(.green)
                                    .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                                    .foregroundColor(.white)
                                    
                                    Button("Не пойду") {
                                        Task {
                                            usersEventStatus = await Network().discardUsersEventStatus(eventId: event.id ?? "")
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .font(.system(size: 13))
                                    .foregroundColor(.red)
                                }
                            }
                            if usersEventStatus.status == "recorded"{
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Запись на мероприятие")
                                        .font(.headline)
                                    HStack(spacing: 20) {
                                        Text("\(Image(systemName: "checkmark")) Запись подтверждена")
                                            .frame(maxWidth: .infinity, minHeight: 20)
                                            .padding(4)
                                            .background(.green)
                                            .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                                            .foregroundColor(.white)
                                        
                                        Button("Отменить") {
                                            Task {
                                                usersEventStatus = await Network().discardUsersEventStatus(eventId: event.id ?? "")
                                            }
                                        }
                                        .foregroundColor(.red)
                                    }
                                    
                                    Text("Свободных мест:  \(event.entry_status?.available_seats ?? 0)\nЗовите друзей и знакомых")
                                        .foregroundStyle(.green)
                                }
                                .font(.system(size:13))
                            }
                        }
                            if event.reserve ?? false && event.entry_status?.available_seats ?? 0 == 0 {
                                if usersEventStatus.status == "in_reserve"{
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Запись на мероприятие")
                                            .font(.headline)
                                        HStack(spacing: 20) {
                                            Text("\(Image(systemName: "clock")) Запись в резерв")
                                                .frame(maxWidth: .infinity, minHeight: 20)
                                                .padding(4)
                                                .background(.orange)
                                                .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                                                .foregroundColor(.white)
                                            
                                            Button("Отменить") {
                                                Task {
                                                    usersEventStatus = await Network().discardUsersEventStatus(eventId: event.id ?? "")
                                                    print(usersEventStatus.status)
                                                }
                                            }
                                            .foregroundColor(.red)
                                        }
                                        
                                        Text("Ваша очередь:  \(event.entry_status?.queue ?? 0)")
                                            .foregroundStyle(.orange)
                                    }
                                    .font(.system(size:13))
                                }
                                if ["not_found", "not_going"].contains(usersEventStatus.status) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Запись на мероприятие")
                                            .font(.headline)
                                        Text("Все места заняты, но вы сможете записаться в резерв. Если место перед вами освободиться, вы сможете учавстовать в мероприятии")
                                            .font(.system(size: 15))
                                        Text("Человек в резерве: \(event.entry_status?.queue ?? 0)")
                                            .foregroundStyle(.orange)
                                        Button("Записаться в резерв") {
                                            Task {
                                                usersEventStatus = await Network().getUsersEventStatus(eventId: event.id ?? "")
                                                print(usersEventStatus.status)
                                            }
                                        }
                                        .frame(maxWidth: .infinity, minHeight: 20)
                                        .padding(8)
                                        .background(.orange)
                                        .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                                        .foregroundColor(.white)
                                        
                                        Button("Не пойду") {
                                            Task {
                                                usersEventStatus = await Network().discardUsersEventStatus(eventId: event.id ?? "")
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .font(.system(size: 13))
                                        .foregroundColor(.red)
                                    }
                                }
                        } else {
                            Text("К сожалению, все места заняты")
                                .foregroundStyle(.red)
                                .font(.system(size: 15))
                            Text(String(event.entry_status?.available_seats ?? 0 == 0))
                        }
                        
                    } else {
                        Text("Запись на мероприятие завершена")
                            .foregroundStyle(.red)
                            .font(.system(size: 15))
                    }
                    
                }
                
                
                
            }
            .padding()
            
        }
        .refreshable(action: {
            event = await Network().getEvent(eventId: eventId ?? "efc053bd-487d-4fc1-963e-4243c06b4785")
            print(event.user_status)
        })
        .task {
            event = await Network().getEvent(eventId: eventId ?? "efc053bd-487d-4fc1-963e-4243c06b4785")
            usersEventStatus.status = event.user_status
            print(event.user_status)
        }
    }
}


#Preview {
    EventRetrieveView()
}
