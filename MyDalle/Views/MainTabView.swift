//
//  MainTabView.swift
//  MyDalle
//
//  Created by Илья Дубенский on 10.03.2023.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ImageGeneratorView()
                .tabItem {
                    Image(systemName: "pencil.circle.fill")
                    Text("Image Generation")
                }
            ChatDavinciView()
                .tabItem {
                    Image(systemName: "message.circle")
                    Text("Chat With AI")
                }
        }
        .tint(.blue.opacity(0.8))
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
