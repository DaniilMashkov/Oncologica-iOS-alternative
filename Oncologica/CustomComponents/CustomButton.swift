import Foundation
import SwiftUI


//struct FilterButton: View {
//    var body: some View{
//        Button
//    }
//}

struct CustomButton: ButtonStyle {
    @State var text: String
    @State var color: Color?
    @State var size: CGFloat
    @State var action: Bool? = false
    @State var checked: Bool? = false
    
    
    func makeBody(configuration: Configuration) -> some View{
        configuration.label
        .font(.system(size: size))
        .padding(8)
        .background(configuration.isPressed  ? setColor() : setColor().opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
        .foregroundColor(checked ?? false || configuration.isPressed ? .white : setColor())
        
    }
    
    func setColor() -> Color {
        if text == "Не пойду" {
            return Color(.red)
        }
        if ["Записан", "Мастер-класс"].contains(text) {
            return Color(.green)
        }
        if text == "Очно" {
            return Color(.cyan)
        }
        if text == "Встреча команды" {
            return Color(.purple)
        }
        if text == "Прямой эфир" || checked == true {
            return Color(.orange)
        } else {
            return Color(.gray)
        }
    }
}


//#Preview {
//    CustomButton(text: "yooo", size: 12)
//}
