//
//  LeaderboardView.swift
//  GeoSnake2
//
//  Created by iosdev on 13.12.2021.
//

import SwiftUI

struct LeaderboardView: View {
    
    @State var scores = [Highscore]()
    
    var body: some View {
        VStack {
        
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
            Api().loadData { (scores) in self.scores = scores} }
        }
    }

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
        }
    }

