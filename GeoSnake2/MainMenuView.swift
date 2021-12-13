//
//  MainMenu.swift
//  GeoSnake2
//
//  Created by iosdev on 23.11.2021.
//
import SwiftUI

class Nickname: ObservableObject {
    var nickname : String = "" {
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
                NavigationLink(destination: GameView()) {
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
                    Image(systemName: "flag.filled.and.flag.crossed").font(.system(size: 20, weight: .light))
                    
                }
                VStack {
                    NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape").font(.system(size: 20, weight: .light))
                }
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

