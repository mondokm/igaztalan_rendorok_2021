import SwiftUI

struct BlueText: View {
    var text = "MyText"
    var body: some View {
        Text(text)
            .fontWeight(.bold)
            .font(.system(size: 20))
            .foregroundColor(Color.accentColor)
    }
}

struct CustomText_Previews: PreviewProvider {
    static var previews: some View {
        BlueText()
    }
}
