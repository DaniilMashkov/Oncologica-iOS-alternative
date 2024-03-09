import Foundation
import SwiftUI


struct AuthView: View {
    @State private var serverValid: Bool = true
    @State private var emailValid: Bool = false
    @State private var passwordValid: Bool = false
    @State private var password = ""
    @State private var email = ""
    @AppStorage("isLoading") var isLoading: Bool = false
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                ProgressView()
                    .controlSize(.extraLarge)
                    .opacity(isLoading ? 1 : 0)
                VStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text ("Вход")
                            .font(.title)
                        Text(serverValid ? "" : "Введён неверный пароль или Email")
                            .font(.system(size: 12))
                            .foregroundStyle(.red)
                    }
                    .frame(width: 330, alignment: .leading)
                    .padding([.vertical, .all])
                    
                    VStack(spacing: 15) {
                        VStack {
                            Text("Email")
                                .frame(width: 330, alignment: .leading)
                                .font(.system(size: 10))
                            
                            TextField("example@oncologica. ru", text: $email)
                                .onChange(of: email) {
                                    if emailValidate(email) {
                                        emailValid = true
                                    } else {
                                        emailValid = false
                                    }
                                }
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .padding([.vertical, .all])
                                .frame(height: 50)
                                .overlay ( !emailValid && email != "" || !serverValid ? RoundedRectangle(cornerRadius: 25).stroke(.red, lineWidth: 2).opacity(0.3) :
                                    RoundedRectangle(cornerRadius: 25).stroke(.secondary, lineWidth: 2).opacity(0.3)
                                    )
                            Text("Введите корректный Email")
                                .frame(width: 330, alignment: .leading)
                                .foregroundColor(.red)
                                .font(.system(size: 10))
                                .opacity((!emailValid && email != "") ? 1 : 0)
                        }
                        
                        VStack {
                            Text("Пароль")
                                .frame(width: 330, alignment: .leading)
                                .font(.system(size: 10))
                            SecureField("", text: $password)
                                .onChange(of: password) {
                                    if passwowordLenghtValidate(password) {
                                        passwordValid = true
                                    } else {
                                        passwordValid = false
                                    }
                                }
                                .textInputAutocapitalization(.never)
                                .padding([.vertical, .all])
                                .frame(height: 50)
                                .overlay ((!passwordValid && password != "") || !serverValid ? RoundedRectangle(cornerRadius: 25).stroke(.red, lineWidth: 2).opacity(0.3) : RoundedRectangle(cornerRadius: 25).stroke(.secondary, lineWidth: 2).opacity(0.3))
                            Text("Введите минимум 8 символов")
                                .frame(width: 330, alignment: .leading)
                                .foregroundColor(.red)
                                .font(.system(size: 10))
                                .opacity((!passwordValid && password != "") ? 1 : 0)
                        }
                        
                    }
                    .frame(width: 330)
                    Spacer()
                    NavigationLink("Не помню пароль") {
                        Text("password recovery")
                    }
                    .foregroundStyle(.blue)
                    .frame(width: 330, alignment: .leading)
                    .font(.system(size: 12))
                    Spacer()
                    Button(action:  {
                        Task {
                            await serverValid = Network().getRefreshToken(email:email, password: password)
                        }
                        }) {Text("Войти")
                                .frame(width: 340, height: 50)
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).stroke(.orange)
                                )
                            }
                        .disabled(!emailValid || !passwordValid)
                        .background(.orange)
                        .cornerRadius(25)
                    
                    Spacer()
                    NavigationLink("Зарегистрироваться") {
                        Text("sign up")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .frame(width: 350, height: 390)
                .blur(radius: isLoading ? 3.0 : 0)
                .disabled(isLoading)
            }
        }
    }
}


#Preview {
    AuthView()
}
