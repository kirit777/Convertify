
import SwiftUI

struct SplashScreen: View {
    @State private var moveConv = false
    @State private var moveErtify = false
    @State private var showMainView = false
    
    var body: some View {
        ZStack {
            if showMainView {
                GridListToggleView()
            } else {
                VStack {
                    HStack(spacing: 0) {
                        Text("Conv")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .offset(x: moveConv ? 0 : -UIScreen.main.bounds.width)
                            .animation(.easeIn(duration: 1), value: moveConv)
                        
                        Text("ertify")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .offset(x: moveErtify ? 0 : UIScreen.main.bounds.width)
                            .animation(.easeIn(duration: 1), value: moveErtify)
                    }
                    .onAppear {
                        // Trigger the animations
                        withAnimation(.easeIn(duration: 1.5)) {
                            moveConv = true
                            moveErtify = true
                        }
                        
                        // After the animation completes, show the main view
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.easeOut(duration: 1.0)) {
                                showMainView = true
                            }
                        }
                    }
                }
                .transition(.opacity)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}


struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
