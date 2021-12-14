//
//  MainMenu.swift
//  GeoSnake2
//
//  Created by iosdev on 23.11.2021.
//
import SwiftUI

class Nickname: ObservableObject {
   @Published var nickname : String = "" {
        willSet(newNickname) {
            print(newNickname)
        }
    }
}

struct MainMenuView: View {
    @ObservedObject var data = Nickname()
    var body: some View {
        NavigationView {
        VStack {
            VStack {
                Text("GeoSnake")
                    .font(.largeTitle)
            }
            Spacer()
            VStack {
                NavigationLink(destination: GameView(nickname: data)) {
                    Image(systemName: "arrowtriangle.right.circle").font(.system(size: 50, weight: .light))
                }
            }
            Spacer()
            Spacer()
            VStack {
                TextField("Nickname:", text: $data.nickname).padding(.horizontal, 15.0).textInputAutocapitalization(.never).disableAutocorrection(true).foregroundColor(Color.pink).accentColor(Color.pink).textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Spacer()
            Spacer()
            HStack {
                VStack {
                    NavigationLink(destination: LeaderboardView(nickname: data)) {
                    Image(systemName: "flag.filled.and.flag.crossed").font(.system(size: 20, weight: .light))
                }.buttonStyle(PlainButtonStyle())
                }
                VStack {
                    NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape").font(.system(size: 20, weight: .light))
                }.buttonStyle(PlainButtonStyle())
            }
        }
    }.background(Image(uiImage: UIImage(named: "download")!)
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all))
        }
    }
}
    
struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}

