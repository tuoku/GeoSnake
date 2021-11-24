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
    var body: some View {
        VStack {
              MapView()
            }
        
    }
    
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MapView: UIViewRepresentable {
  typealias UIViewType = MKMapView
    @State var route = [CLLocationCoordinate2D]()


    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
      }
  
  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView()
    mapView.delegate = context.coordinator
    
    
    
    
    
    
    let region = MKCoordinateRegion(
      center: CLLocationCoordinate2D(latitude: 60.223623633557104, longitude: 24.758503049950143),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    mapView.setRegion(region, animated: true)
    
    route.append(CLLocationCoordinate2D(latitude: 60.221412099276925, longitude: 24.74992471029274))
    
    route.append(CLLocationCoordinate2D(latitude: 60.22255385605699, longitude: 24.749701065905217))
    //pls ignore
    
        let polyline = MKPolyline(coordinates: route, count: route.count)
               // mapView.addAnnotations([p1, p2])
                mapView.addOverlay(polyline)
                mapView.setVisibleMapRect(
                  polyline.boundingMapRect,
                  edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                  animated: true)
        return mapView

    
    
    
    
  }
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
          let renderer = MKPolylineRenderer(overlay: overlay)
          renderer.strokeColor = .systemBlue
          renderer.lineWidth = 5
          return renderer
        }
      }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {}
}
