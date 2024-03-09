import Foundation
import SwiftUI

struct NotificationCountView : View {
    @State var value = 0
    
    private let size = 20.0
    private let x = 20.0
    private let y = 0.0
    
    var body: some View {
        ZStack {
            Capsule()
                .fill(.orange)
                .frame(width: size * widthMultplier(), height: size, alignment: .topTrailing)
                .position(x: x, y: y)
            
            if value < 100 {
                Text("\(value)")
                    .foregroundColor(.white)
                    .font(Font.caption)
                    .position(x: x, y: y)
            } else {
                Text("99+")
                    .foregroundColor(.white)
                    .font(Font.caption)
                    .frame(width: size * widthMultplier(), height: size, alignment: .center)
                    .position(x: x, y: y)
            }
        }
        .task {
            await value = Network().getNotificationCount()
        }
        .opacity(value == 0 ? 0 : 1)
    }
    
    
    func widthMultplier() -> Double {
        if value < 10 {
            // one digit
            return 1.0
        } else if value < 100 {
            // two digits
            return 1.5
        } else {
            // too many digits, showing 99+
            return 2.0
        }
    }
}
