//
//  Scores.swift
//  GeoSnake2
//
//  Created by iosdev on 13.12.2021.
//

import Foundation

struct Highscore: Codable, Identifiable {
    let id = UUID()
    var nickname: String
    var highscore: String
}

class Api : ObservableObject {
    @Published var highscores = [Highscore]()
    
    func loadData(completion:@escaping ([Highscore]) -> ()) {
        guard let url = URL(string: "https://users.metropolia.fi/~tuomakuh/geosnake/?action=top") else {
            print("Invalid url...")
            return
        }
        URLSession.shared.dataTask(with: url) { data,response,error in
            let highscores = try! JSONDecoder().decode([Highscore].self, from: data!)
            print(highscores)
            DispatchQueue.main.async {
                completion(highscores)
            }
        }.resume()
    }
    
}


