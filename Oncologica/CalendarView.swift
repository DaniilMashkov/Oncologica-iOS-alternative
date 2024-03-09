import SwiftUI


struct CalendarView: View {
    @State var dates = [Date]()
    @State var currentDate = Date()
    @State var showingFilters = false
    @State var filtersCount: Int?
    @StateObject var filters = eventsFilters()
    
    @AppStorage("accessToken") private var accessToken = " "
    @AppStorage("isLoading") var isLoading: Bool = false
    @State var calendarEvents = [CalendarEvents]()
    @StateObject var events = EventObj()
    
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            //            ScrollViewReader { value in
            //                ScrollView(.horizontal) {
            //                    LazyHStack {
            //                        ForEach(currentDate.yearsRange(get: "month"), id: \.self) { m in
            //
            //
            
            VStack {
                HStack {
                    Button {
                        guard let newDate = Calendar.current.date(
                            byAdding: .month,
                            value: -1,
                            to: currentDate
                        ) else {
                            return
                        }
                        currentDate = newDate
                        
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundStyle(.gray)
                            .padding(.all)
                    }
                    
                    Menu {
                        ForEach(currentDate.yearsRange(get: "year"), id: \.self) {y in
                            Button(y.toString("y"), action: {
                                let newDate = y
                                currentDate = newDate
                            })
                        }
                    } label: {
                        HStack {
                            Text(currentDate.toString("y"))
                            Image(systemName: "chevron.down")
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .frame(maxWidth: .infinity)
                    
                    Menu {
                        ForEach(currentDate.monthsRange(), id: \.self) {m in
                            Button(m.toString("MMMM"), action: {
                                let newDate = m
                                currentDate = newDate
                            })
                        }
                    } label: {
                        HStack {
                            Text(currentDate.toString("MMMM"))
                            Image(systemName: "chevron.down")
                            
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .frame(maxWidth: .infinity)
                    
                    
                    Button {
                        guard let newDate = Calendar.current.date(
                            byAdding: .month,
                            value: 1,
                            to: currentDate
                        ) else {
                            return
                        }
                        currentDate = newDate
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundStyle(.gray)
                    }
                    .padding(.all)
                }
                
                VStack {
                    HStack {
                        ForEach(Date().weekDays(), id:\.self) {
                            day in Text(day)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    
                    LazyVGrid( columns: columns, spacing: 10) {
                        ForEach(0..<currentDate.firstDayOfTheMonth(), id: \.self) { i in Spacer()
                        }
                        
                        ForEach(currentDate.currentMonthRange(), id: \.self) { date in
                            VStack(spacing:5) {
                                Button(date.toString("d"), action: {
                                    
                                    if dates.count >= 2 {
                                        if dates.contains([date]) {
                                            dates = [date]
                                        }
                                        if dates.last! < date {
                                            dates.insert(date, at: 0)
                                        }
                                        else {
                                            dates.insert(date, at: 1)
                                        }
                                    }
                                    else {
                                        dates.append(date)
                                    }
                                    dates.sort()
                                    dates = currentDate.datesRangeArray(from: dates.first!, to: dates.last!)
                                    Task {
                                        events.events = await Network().getEvents(filters: filters, dates: dates)
                                    }
                                })
                                .frame(width: 33, height: 33)
                                .background(dates.contains(date) ? .orange : .clear).opacity(0.8)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                                .buttonStyle(PlainButtonStyle())
                                
                                HStack() {
                                    
                                    ForEach(calendarEvents.filter(){$0.date == date.toString("y-MM-dd")}) {e in
                                        
                                        Circle()
                                            .size(CGSize(width: 5, height: 5))
                                            .frame(maxWidth: 5)
                                            .foregroundStyle(Color.init(hex:e.category?.theme?.font ?? ""))
                                    }
                                    
                                }
                                .frame(maxWidth: 35, maxHeight: 20)
                            }
                        }
                    }
                    //                                }
                    
                    .frame(minWidth: 380)
                    .padding([.vertical])
                    
                    //                            }
                    //                        }
                    //                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
            }
            Text("Мероприятия \(events.events.count)")
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.horizontal])
            EventView(events: events, isLoading: isLoading)
        }
        .task {
            calendarEvents = await Network().getCalendarBasics(filters:filters)
        }
        .blur(radius: showingFilters ? 5 : 0)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingFilters.toggle()
                    
                } label: {
                    ZStack {
                        Image(systemName: "bookmark")
                            .sheet(isPresented: $showingFilters) {
                                CalendarFiltersView(eventFilters: filters)
                                    .presentationDetents([.fraction(0.7)])
                                    .presentationDragIndicator(.visible)
                                    .onDisappear{
                                        Task {
                                            events.events = []
                                            calendarEvents = await Network().getCalendarBasics(filters:filters)
                                            filtersCount = filters.categories.count-1+filters.speakers.count-1+filters.statuses.count-1+filters.venues.count-1
                                        }}
                            }
                            .font(.title3)

                        if filtersCount ?? 0 > 0 {
                            Image(systemName: "\(filtersCount ?? 0).circle.fill")
                                .position(CGPoint(x: 0, y: 20.0))
                        }
                            
                    }
                }
            }
        }
        
    }
    
}


#Preview {
    CalendarView(filters: eventsFilters())
}
