//
//  Map.swift
//  YourSchool
//
//  Created by 임준협 on 2023/01/26.
//

import SwiftUI
import MapKit
struct AnnotatedItem: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}
struct schoolMapView: View {
    @State var schoolLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36.333065000000005, longitude: 127.34531979051518), span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
    private var pointOfInterest = [
        AnnotatedItem(name: "학교", coordinate: .init(latitude: 36.333065000000005, longitude: 127.34531979051518))
    ]
    var locationManger = CLLocationManager()
    var body: some View {
        NavigationView{
            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height
                ZStack{
                    Map(coordinateRegion: $schoolLocation, showsUserLocation: true, userTrackingMode: .constant(.follow), annotationItems: pointOfInterest){item in
                        MapMarker(coordinate: item.coordinate, tint: .black)
                    }.onAppear(perform: {
                        locationManger.desiredAccuracy = kCLLocationAccuracyBest
                        locationManger.requestWhenInUseAuthorization()
                  })
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            print("didUpdateLocations")
            if let location = locations.first {
                print("lat: \(location.coordinate.latitude)")
                print("lon: \(location.coordinate.longitude)")
            }
        }
//    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.5666791, longitude: 126.9782914), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
//        var body: some View {
//            Map(coordinateRegion: $region)
//        }
}

struct schoolMapView_Previews: PreviewProvider {
    static var previews: some View {
        schoolMapView()
    }
}
