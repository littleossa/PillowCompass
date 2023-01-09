//
//  ContentView.swift
//  littleossaCompass
//
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var pillowCompass = PillowCompass()
    
    var body: some View {
        
        VStack {
            
            Text("この方角に枕を置いて寝ましょう")
                .font(.title2)
                .bold()
            
            Image(systemName: "circle")
                .font(.system(size: 320))
                .fontWeight(.thin)
                .overlay {
                    Image(systemName: "figure.stand")
                        .font(.system(size: 200))
                        .rotationEffect(.degrees(pillowCompass.pillowDegrees ?? 0))
                }
            
            Button {
                Task {
                    await pillowCompass.fetchPillowDegrees()
                }
            } label: {
                RoundedRectangle(cornerRadius: 40)
                    .frame(width: 320, height: 80)
                    .overlay {
                        Label("リルオッサの現在地を更新する",
                              systemImage: "goforward")
                        .foregroundColor(.white)
                    }
            }
        }
        .task {
            await pillowCompass.setup()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
