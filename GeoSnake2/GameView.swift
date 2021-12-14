//
//  ContentView.swift
//
//
//  Created by iosdev on 10.11.2021.
//

import SwiftUI
import MapKit

struct GameView: View {
    
    private let speechRecognizer = SpeechRecognizer()
    
    @State private var isRecording = false
        
    @StateObject var snake = Snake()
    @StateObject var input = DirInput()
    @StateObject var score = Score()
    @StateObject var gameover = GameOver()
    @StateObject var locationManager = LocationManager()
    
    @State private var hasLoaded = false
    
    @ObservedObject var nickname: Nickname
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        if hasLoaded {
        VStack {
            Text("Score: \(score.score)").font(.system(size:30))
            HStack {
                Button("left", action: turnLeft)
                Button("right", action: turnRight)
                Button("up", action: turnUp)
                Button("down", action: turnDown)
            }
            MapView(snake: snake, input: input, score: score, gameover: gameover, locationManager: locationManager)
        }.sheet(isPresented: $gameover.gameover, onDismiss: didDismiss){
            VStack {
                Text("Game Over!").font(.system(size:30))
                Text("Your score: \(score.score)").font(.system(size:20))
                NavigationView {
                            NavigationLink(destination: LeaderboardView(nickname: nickname)) {
                                Text("Go!")
                            }
                        }
            }.onAppear() {
                if !nickname.nickname.isEmpty {
                guard let url = URL(string: "https://users.metropolia.fi/~tuomakuh/geosnake/?action=set&nickname=\(nickname.nickname)&highscore=\(score.score)") else { fatalError("Missing URL") }

                    let urlRequest = URLRequest(url: url)

                    let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                        if let error = error {
                            print("Request error: ", error)
                            return
                        }

                        guard let response = response as? HTTPURLResponse else { return }

                        if response.statusCode == 200 {
                           print("score uploaded")
                        }
                    }

                    dataTask.resume()
                }
            }
        }
        } else {
            VStack {
                    ProgressView()
            }.onReceive(locationManager.$lastLocation) { location in
                if location != nil {
                    hasLoaded = true
                }
                speechRecognizer.record(to: $input.transcript)
                            }
        }
            

    }
    
    func didDismiss(){
        dismiss()
        gameover.gameover = false
    }
    
    func turnLeft(){
        input.input = "LEFT"
    }
    
    func turnRight(){
        input.input = "RIGHT"
    }
    func turnUp(){
        input.input = "UP"
    }
    func turnDown(){
        input.input = "DOWN"
    }
    
    
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MapView: UIViewRepresentable {
    
    typealias UIViewType = MKMapView
    @ObservedObject var snake: Snake
    @ObservedObject var input: DirInput
    @ObservedObject var score: Score
    @ObservedObject var gameover: GameOver
    @ObservedObject var locationManager: LocationManager
    
    
    var userLatitude: Double {
            return locationManager.lastLocation?.coordinate.latitude ?? 0
        }
        
        var userLongitude: Double {
            return locationManager.lastLocation?.coordinate.longitude ?? 0
        }
    
    var drawingTimer: Timer?
    @State var polyline: MKPolyline?
    let polyQ = DispatchQueue.global(qos: .userInteractive)
    
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        
        snake.coords = [CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude)]
        
        
       
        
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude),
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        mapView.setRegion(region, animated: true)
        
        _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true)  { _ in
            if(gameover.gameover == false) {
                score.score += 1
            }
            
        }
        
        _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
            if(gameover.gameover == false) {
            DispatchQueue.main.async {
                let a = snake.coords.last!.longitude
                let aa = snake.coords.last!.latitude
                var nc: CLLocationCoordinate2D
                switch input.input {
                case "UP":
                    nc = CLLocationCoordinate2D(latitude: aa + 0.0002, longitude: a)
                case "RIGHT":
                    nc = CLLocationCoordinate2D(latitude: aa, longitude: a + 0.0002)
                case "LEFT":
                    nc = CLLocationCoordinate2D(latitude: aa, longitude: a - 0.0002)
                case "DOWN":
                    nc = CLLocationCoordinate2D(latitude: aa - 0.0002, longitude: a)
                default:
                    nc = CLLocationCoordinate2D(latitude: aa + 0.0002, longitude: a)
                }
                
                if(snake.coords.contains(where: { $0.latitude == nc.latitude && $0.longitude == nc.longitude })){
                    gameover.gameover = true
                }
                if(CLLocation(latitude: nc.latitude, longitude: nc.longitude).distance(from: CLLocation(latitude: userLatitude, longitude: userLongitude)) > 1000) {
                    gameover.gameover = true
                }
                snake.coords.append(nc)
                
                if(snake.coords.count > max(10, (score.score / 5))) {
                    snake.coords.remove(at: 0)
                }
            }
            }
        }
        
        return mapView
        
    }
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKCircle{
                let renderer = MKCircleRenderer(overlay: overlay)
                      renderer.fillColor = UIColor.black.withAlphaComponent(0.0)
                      renderer.strokeColor = UIColor.red
                      renderer.lineWidth = 10
                      return renderer
                }
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 10
            renderer.fillColor = .green
            return renderer
        }
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        
        
        
        let polyline = MKPolyline(coordinates: snake.coords, count: snake.coords.count)
        // mapView.addAnnotations([p1, p2])
        uiView.removeOverlays(uiView.overlays)
        let circle = MKCircle(center: CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude), radius: 1000)
        uiView.addOverlay(circle)
        
        uiView.addOverlay(polyline)
        
        uiView.delegate = context.coordinator
    }
}

class Snake: ObservableObject {
    @Published var coords : Array<CLLocationCoordinate2D> = [CLLocationCoordinate2D(latitude: 60.221412099276925, longitude: 24.74992471029274), CLLocationCoordinate2D(latitude: 60.22255385605699, longitude: 24.749701065905217)]
    
}

class DirInput: ObservableObject {
    @Published var input : String = "UP"
    @Published var transcript: String = "" {
        didSet{
            print("DIR " + self.transcript)
            if self.transcript.components(separatedBy: " ").last?.uppercased() == "LEFT" {
                input = "LEFT"
                self.transcript = ""
            }
            if self.transcript.components(separatedBy: " ").last?.uppercased() == "RIGHT" {
                input = "RIGHT"
                self.transcript = ""
            }
            if self.transcript.components(separatedBy: " ").last?.uppercased() == "UP" {
                input = "UP"
                self.transcript = ""
            }
            if self.transcript.components(separatedBy: " ").last?.uppercased() == "DOWN" {
                input = "DOWN"
                self.transcript = ""
            }
        }
    }
}

class Score: ObservableObject {
    @Published var score : Int = 1
}

class GameOver: ObservableObject {
    @Published var gameover: Bool = false
}


