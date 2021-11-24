//
//  MainMenu.swift
//  GeoSnake2
//
//  Created by iosdev on 23.11.2021.
//

import SwiftUI

struct MainMenuView: View {
    @State private var nickname: String = ""
    
    var body: some View {
        NavigationView {
        VStack {
            VStack {
                Text("GeoSnake")
                    .font(.largeTitle)
            }
            Spacer()
            VStack {
                NavigationLink(destination: GameView()) {
                    Image(systemName: "arrowtriangle.right.circle").font(.system(size: 50, weight: .light))
            }
            }
            Spacer()
            Spacer()
            VStack {
                TextField("Nickname:", text: $nickname).padding(.horizontal, 15.0).textInputAutocapitalization(.never).disableAutocorrection(true)
            }
            Spacer()
            Spacer()
            HStack {
                VStack {
                    Image(systemName: "flag.filled.and.flag.crossed").font(.system(size: 20, weight: .light))
                    
                }
                VStack {
                    Image(systemName: "gearshape").font(.system(size: 20, weight: .light))
                }
            }
        }
        }
       
    }
    
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
