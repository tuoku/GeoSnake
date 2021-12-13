//
//  LeaderboardView.swift
//  GeoSnake2
//
//  Created by iosdev on 13.12.2021.
//

import SwiftUI

struct LeaderboardView: View {
    var body: some View {
        VStack {
            Image(uiImage: UIImage(named: "avatarplaceholder")!)
                .resizable()
                .clipped()
                .clipShape(Circle())
                .frame(width: 100, height: 100, alignment: .center)
        }
    }

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
        }
    }
}
