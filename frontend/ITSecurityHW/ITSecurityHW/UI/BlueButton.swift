import SwiftUI

struct BlueButton: View {
    public var buttonText: String
    public var tapped: () -> Void

    var body: some View {
        Button(action: tapped) {
            Text(buttonText)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .padding(20)
                .frame(width: UIScreen.main.bounds.width - 50)
                .background(Color.accentColor)
                .foregroundColor(Color.white)
                .cornerRadius(8)
        }
    }
}

struct LoginOrRegisterButton_Previews: PreviewProvider {
    static var previews: some View {
        BlueButton(buttonText: "Login", tapped: {})
    }
}
