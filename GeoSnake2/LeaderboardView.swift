//
//  LeaderboardView.swift
//  GeoSnake2
//
//  Created by iosdev on 13.12.2021.
//

import SwiftUI

struct LeaderboardView: View {
    
    @State var scores = [Highscore]()
    @ObservedObject var nickname: Nickname
    
    var body: some View {
        VStack {
            HStack {
                Image(uiImage: UIImage(named: "avatarplaceholder")!)
                    .resizable()
                    .clipped()
                    .clipShape(Circle())
                    .frame(width: 100, height: 100, alignment: .leading)
                Text(nickname.nickname)
            }
            VStack {
                List(scores) { score in
                    HStack {
                        Text("\(score.nickname)")
                        Spacer()
                        Text("\(score.highscore)")
                    }
                    
                }
            }
            
        }.onAppear() {
            Api().loadData { (scores) in self.scores = scores} }.navigationTitle("Scores")
        }
    }

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
        }
    }

