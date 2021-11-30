//
//  ContentView.swift
//  vittu-app
//
//  Created by iosdev on 10.11.2021.
//

import SwiftUI
import MapKit

struct GameView: View {
    
    // private let speechRecognizer = SpeechRecognizer()
    @State private var transcript = ""
    @State private var isRecording = false
    
    @StateObject var snake = Snake()
    @StateObject var input = DirInput()
    @StateObject var score = Score()
    @StateObject var gameover = GameOver()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Score: \(score.score)").font(.system(size:30))
            HStack {
                Button("left", action: turnLeft)
                Button("right", action: turnRight)
                Button("up", action: turnUp)
                Button("down", action: turnDown)
            }
            MapView(snake: snake, input: input, score: score, gameover: gameover)
        }.sheet(isPresented: $gameover.gameover, onDismiss: didDismiss){
            VStack {
                Text("Game Over!").font(.system(size:30))
                Text("Your score: \(score.score)").font(.system(size:20))
                
            }
            
        }
    }
    
    func didDismiss(){
        dismiss()
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
    
    var drawingTimer: Timer?
    @State var polyline: MKPolyline?
    let polyQ = DispatchQueue.global(qos: .userInteractive)
    
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 60.223623633557104, longitude: 24.758503049950143),
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        mapView.setRegion(region, animated: true)
        
        var scoreTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true)  { _ in
            if(gameover.gameover == false) {
                score.score += 1
            }
            
        }
        
        var timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
            if(gameover.gameover == false) {
            DispatchQueue.main.async {
                let a = snake.coords.last!.longitude
                let aa = snake.coords.last!.latitude
                var nc: CLLocationCoordinate2D
                switch input.input {
                case "UP":
                    nc = CLLocationCoordinate2D(latitude: aa + 0.0001, longitude: a)
                case "RIGHT":
                    nc = CLLocationCoordinate2D(latitude: aa, longitude: a + 0.0001)
                case "LEFT":
                    nc = CLLocationCoordinate2D(latitude: aa, longitude: a - 0.0001)
                case "DOWN":
                    nc = CLLocationCoordinate2D(latitude: aa - 0.0001, longitude: a)
                default:
                    nc = CLLocationCoordinate2D(latitude: aa + 0.0001, longitude: a)
                }
                
                if(snake.coords.contains(where: { $0.latitude == nc.latitude && $0.longitude == nc.longitude })){
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
        
        uiView.addOverlay(polyline)
        
        let pline = MKPolyline(coordinates: [CLLocationCoordinate2D(latitude: 60.221412099276925, longitude: 24.74992471029274), CLLocationCoordinate2D(latitude: 60.22255385605699, longitude: 24.749701065905217)], count: 2)
        
        uiView.delegate = context.coordinator
    }
}

class Snake: ObservableObject {
    @Published var coords : Array<CLLocationCoordinate2D> = [CLLocationCoordinate2D(latitude: 60.221412099276925, longitude: 24.74992471029274), CLLocationCoordinate2D(latitude: 60.22255385605699, longitude: 24.749701065905217)]
    
}

class DirInput: ObservableObject {
    @Published var input : String = "UP"
}

class Score: ObservableObject {
    @Published var score : Int = 1
}

class GameOver: ObservableObject {
    @Published var gameover: Bool = false
}
