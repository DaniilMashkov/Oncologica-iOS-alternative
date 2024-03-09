//
//  CalendarFiltersView.swift
//  Oncologica
//
//  Created by Daniil Mashkov on 31.12.2023.
//

import Foundation
import SwiftUI


class eventsFilters: ObservableObject {
    @Published var statuses = [""]
    @Published var categories = [""]
    @Published var venues = [""]
    @Published var speakers = [""]
}


let rows = [GridItem(.adaptive(minimum: 120))]


let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible()),
]

struct CalendarFiltersView: View {
    @ObservedObject var eventFilters: eventsFilters
    @State var filters = Filters()
    @Environment(\.dismiss) var dismiss
    @AppStorage("isLoading") var isLoading: Bool = false
    
    var body: some View {
//        Button("Закрыть"){
//            dismiss()
//        }
//        .padding()
//        .foregroundStyle(.orange)
//        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .topTrailing)
        ZStack {
            ScrollView {
                VStack(spacing: 30) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Статус")
                            .font(.title2)
                        
                        HStack {
                            ForEach(filters.statuses?.sorted(by: >) ?? Array(Dictionary()), id: \.key) {key, value in
                                Button(key){
                                    if let ind = eventFilters.statuses.firstIndex(of: value){
                                        eventFilters.statuses.remove(at: ind)
                                    } else {
                                        eventFilters.statuses.append(value)
                                    }
                                }
                                .font(.system(size: 13))
                                .padding(8)
                                .background(eventFilters.statuses.contains(value) ? .clear.filterButton(text: key) : .clear.filterButton(text: key).opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                                .foregroundStyle(eventFilters.statuses.contains(value) ? .white : .clear.filterButton(text: key))
                            }
                        }
                        
                        Text("Категория")
                            .font(.title2)
                        
                        LazyVGrid(columns: rows, alignment: .leading) {
                            ForEach(filters.categories ?? [""], id: \.self) {cat in
                                Button(cat){
                                    if let ind = eventFilters.categories.firstIndex(of: cat) {
                                        eventFilters.categories.remove(at: ind)
                                    } else {
                                        eventFilters.categories.append(cat)
                                    }
                                }
                                .font(.system(size: 13))
                                .fixedSize(horizontal: true, vertical: false)
                                .padding(8)
                                .background(eventFilters.categories.contains(cat) ? .clear.filterButton(text: cat) : .clear.filterButton(text: cat).opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                                .foregroundStyle(eventFilters.categories.contains(cat) ? .white : .clear.filterButton(text: cat))
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Место")
                                .font(.title2)
                            LazyVGrid(columns: rows, alignment: .leading) {
                                ForEach(filters.venues ?? [""], id: \.self) {venue in
                                    Button(venue){
                                        if let ind = eventFilters.venues.firstIndex(of: venue) {
                                            eventFilters.venues.remove(at: ind)
                                        } else {
                                            eventFilters.venues.append(venue)
                                        }
                                    }
                                    .font(.system(size: 13))
                                    .fixedSize(horizontal: true, vertical: false)
                                    .padding(8)
                                    .background(eventFilters.venues.contains(venue) ? .clear.filterButton(text: venue) : .clear.filterButton(text: venue).opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                                    .foregroundStyle(eventFilters.venues.contains(venue) ? .white : .clear.filterButton(text: venue))
                                }
                            }
                        }
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Ведущий")
                                .font(.title2)
                            
                            LazyVGrid(columns: rows, alignment: .leading) {
                                ForEach(filters.speakers?.sorted(by: >) ?? Array(Dictionary()), id: \.key) {key, value in
                                    Button(key) {
                                        if let ind = eventFilters.speakers.firstIndex(of: value) {
                                            eventFilters.speakers.remove(at: ind)
                                        } else {
                                            eventFilters.speakers.append(value)
                                        }
                                    }
                                    .font(.system(size: 13))
 
                                    .padding(8)
                                    .background(eventFilters.speakers.contains(value) ? .clear.filterButton(text: value) : .clear.filterButton(text: value).opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                                    .foregroundStyle(eventFilters.speakers.contains(value) ? .white : .clear.filterButton(text: value))
                                }
                            }
                        }
                    }
                    .tint(.primary)
                    .padding()
                    .blur(radius: isLoading ? 5 : 0)
            }
//                Button(action:  {
//                    Task {
// 
//                    }
//                    }) {Text("Применить")
//                            .frame(width: 370, height: 50)
//                            .foregroundColor(.white)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).stroke(.orange)
//                            )
//                        }
//                    .background(.orange)
//                    .cornerRadius(25)
            }
            ProgressView()
                .controlSize(.extraLarge)
                .opacity(isLoading ? 1 : 0)
        }
        .task {
            await filters = Network().getEventFilters()
        }
    }
}


#Preview {
    CalendarFiltersView(eventFilters: eventsFilters())
}
