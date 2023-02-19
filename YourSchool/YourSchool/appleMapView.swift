//
//  kakaoNaviView.swift
//  YourSchool
//
//  Created by 임준협 on 2023/01/26.
//

import SwiftUI
import MapKit
import CoreLocation

struct pin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
struct AppleMapView: View {
    @State private var directions: [String] = []
    @State private var showDirections = false
    @State var selection = 0
    var body: some View{
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            VStack {
                NavMapView(directions: $directions)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height: h/1.5)
                
                VStack{
                    Text("경로")
                        .font(.largeTitle)
                        .bold()
                    TabView{
                        ForEach(0..<self.directions.count, id: \.self) { i in
                            Text(self.directions[i])
                                .padding()
                                .foregroundColor(Color("scheme"))
                                .background(.primary)
                                .cornerRadius(20)
                        }
                    }.tabViewStyle(PageTabViewStyle())
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                        .padding(.top, -90)
                }
            }
            
        }.onAppear{
            showDirectionsAuto()
        }
        
        
    }
    
    func showDirectionsAuto() {
        if directions.isEmpty{
            showDirections.toggle()
        }
    }
    
}
struct NavMapView: UIViewRepresentable {
    typealias UIViewType = MKMapView

    let locationManager = CLLocationManager()

    @Binding var directions: [String]
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    func makeUIView(context: Context) -> MKMapView {
        var annotationView = MKAnnotationView()

        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        let crntLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: getUserLocaation()[0], longitude: getUserLocaation()[1]), span: MKCoordinateSpan())
        let crntLocationPM = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: getUserLocaation()[0], longitude: getUserLocaation()[1]))
        mapView.setRegion(crntLocation, animated: true)
        mapView.showsUserLocation = true
//        school
        let schoolPM = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 36.333065000000005, longitude: 127.34531979051518))
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: crntLocationPM)
        request.destination = MKMapItem(placemark: schoolPM)
        request.transportType = .walking

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
          guard let route = response?.routes.first else { return }
            let schoolPin = MapPin(title: "School", locationName: "School Location", coordinate: CLLocationCoordinate2D(latitude: 36.333065000000005, longitude: 127.34531979051518))
            let crntPin = MapPin(title: "Start", locationName: "Start Location", coordinate: CLLocationCoordinate2D(latitude: getUserLocaation()[0], longitude: getUserLocaation()[1]))

            mapView.addAnnotations([schoolPin, crntPin])
            mapView.addOverlay(route.polyline)
            mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
            self.directions = route.steps.map { $0.instructions }.filter{ !$0.isEmpty }
            for route in response!.routes {
                let eta = route.expectedTravelTime
                print(eta)
            }
        }
     return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
    func getUserLocaation() -> [Double]{
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        var userCoordinates = locationManager.location?.coordinate
        return [userCoordinates!.latitude, userCoordinates!.longitude]
    }
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let randerer = MKPolylineRenderer(overlay: overlay)
            randerer.strokeColor = .blue
            randerer.lineWidth = 5
            return randerer
        }
    }
}
class MapPin: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate

    }
}
struct AppleMapView_Previews: PreviewProvider {
    static var previews: some View {
        AppleMapView()
    }
}
