import Foundation
import SwiftUI


struct MedicalDataView: View {
    @State var conditions = [PatientCondition]()
    @State var medicalData = MedicalData()
    @State var userId: Int?
    @State var diagnosis = ""
    @State var condition = PatientCondition()
    @State var anamnesis = ""
    @State var files = [MedicalDoc]()
    
    var nw = Network()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 25) {
                VStack(alignment: .leading) {
                    Text("Диагноз")
                        .font(.caption)
                    TextField("Наименование диагноза", text: $diagnosis)
                        .frame(height: 50)
                        .padding(.horizontal)
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke(.secondary, lineWidth: 2).opacity(0.3))
                }
                VStack(alignment: .leading) {
                    Text("Текущее состояние")
                        .font(.caption)
                    
                    Menu {
                        ForEach(conditions) {c in
                            Button(c.name ?? ""){
                                condition = c
                            }
                            
                        }
                    } label: {
                        HStack {
                            Text(condition.name ?? "Выберете" )
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .padding(.horizontal)
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke(.secondary, lineWidth: 2).opacity(0.3))
                    }
                    
                                        }
                VStack(alignment: .leading) {
                    Text("Анамнез")
                        .font(.caption)
                    ZStack {
                        if anamnesis.isEmpty {
                            Text("Опишите ваше состояние здоровья, диагнозы, хронические заболевания и так далее")
                                .padding()
                                .frame(height: 150, alignment: .top)
                        }
                        TextEditor(text: $anamnesis)
                            .frame(height: 150)
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 25).stroke(.secondary, lineWidth: 2).opacity(0.3))
                            .opacity(anamnesis.isEmpty ? 0.85 : 1)
                    }
                }
                Text("Информация необходима для того, чтобы при согласовании помощи собрать о вас полную картину, так как не всегда в выписке онколога можно получить информацию")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                VStack(alignment: .leading, spacing: 10) {
                    Text("Медицинские документы")
                        .font(.title2)
                    Text("Собирайте фотографии и сканы медицинских документов в одном месте")
                        .font(.subheadline)
                    ScrollView(.horizontal) {
                        LazyHStack {
                            Button{
                                
                            }label: {
                                VStack {
                                    Image(systemName: "plus")
                                        .resizable().frame(width: 25, height: 25)
                                }
                                .frame(width: 100, height: 120)
                                .contentShape(Rectangle())
                                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(style: StrokeStyle(lineWidth: 2, dash:[8]))).foregroundColor(.secondary)
                            }
                            ForEach(medicalData.usermedicaldocument_set ?? [MedicalDoc(id: "")], id: \.id) {doc in
                                NavigationLink {
                                    
                                }label: {
                                    Image(uiImage: (UIImage(data: doc.image ?? Data()) ?? UIImage(systemName: "questionmark"))!)
                                        .resizable()
                                        .frame(width: 100, height: 120)
                                        .scaledToFill()
                                        
                                        .contentShape(Rectangle())
                                    
                                
                                }
                            }
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)

            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity, alignment: .topLeading)
            .padding()
            
        }
        
        .task {
            conditions = await nw.getPatientsConditions()
            medicalData = await nw.getMedicalData(userId: 34)
            diagnosis = (medicalData.diagnosis)!
            anamnesis = (medicalData.anamnesis)!
        }
    }
}

#Preview {
    MedicalDataView(userId: 37)
}
