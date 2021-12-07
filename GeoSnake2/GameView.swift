//
//  ContentView.swift
//  vittu-app
//
//  Created by iosdev on 10.11.2021.
//

import SwiftUI
import MapKit

struct GameView: View {
    
    private let speechRecognizer = SpeechRecognizer()
    @State var transcript = ""
    
    @State private var isRecording = false
        
    @StateObject var snake = Snake()
    @StateObject var input = DirInput()
    @StateObject var score = Score()
    @StateObject var gameover = GameOver()
    @StateObject var locationManager = LocationManager()
    @State private var hasLoaded = false
    
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        let transcriptBinding = Binding<String>(
            get: {
            self.transcript
        },
            set: {
                self.transcript = $0
                if transcript.uppercased().contains("VASEN") {
                    turnLeft()
                    self.transcript = ""
                }
                if transcript.uppercased().contains("OIKEA") {
                    turnRight()
                    self.transcript = ""
                }
                if transcript.uppercased().contains("YLÖS") {
                    turnUp()
                    self.transcript = ""
                }
                if transcript.uppercased().contains("ALAS") {
                    turnDown()
                    self.transcript = ""
                }
        })
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
                
            }
            
        }
        } else {
            VStack {
                    ProgressView()
            }.onReceive(locationManager.$lastLocation) { location in
                if location != nil {
                    hasLoaded = true
                }
                speechRecognizer.record(to: transcriptBinding)
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
