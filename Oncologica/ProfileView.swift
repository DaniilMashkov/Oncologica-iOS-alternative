import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("accessToken") private var accessToken = " "
    @AppStorage("refreshToken") private var refreshToken = " "
    @AppStorage("isLoading") var isLoading: Bool = false
    @State var user = User()
    @AppStorage("userEmail") private var userEmail = ""
    @AppStorage("isLogged") private var isLogged: Bool = false
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            HStack{
                NavigationLink {
                    
                }label: {
                    Image(systemName: "person")
                    Text("Личная информация")
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(.secondary)
            }
            HStack{
                NavigationLink {
                    
                }label: {
                    Image(systemName: "doc")
                    Text("Документы")
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(.secondary)
            }
            HStack{
                NavigationLink {
                    MedicalDataView(userId: user.id)
                }label: {
                    Image(systemName: "cross.case")
                    Text("Медицинская информация")
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(.secondary)
            }
            HStack{
                NavigationLink {
                    
                }label: {
                    Image(systemName: "gear")
                    Text("Настройки")
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(.secondary)
            }
            if user.phone != nil && user.phone_confirmed == false {
                NavigationLink {
                    
                } label: {
                    Text("Чтобы вы могли воспользоваться нашими видами помощи, нужно подтвердить номер \(user.phone!)")
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .padding()
                        .background(.orange.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .foregroundColor(.orange)
                        
                }
            }
            Button("Выйти из аккаунта"){
                Keychain().deleteUser(email: userEmail)
                accessToken = ""
                refreshToken = ""
                isLogged = false
            }
            .foregroundStyle(.red)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity, alignment: .leading)
        .padding()
        .task {
            user = await Network().getUserBasics()
            user.phone = "+79131252198"
        }
    }
}


#Preview {
    ProfileView(user: User())
}
