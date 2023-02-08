//
//  MyMapView.swift
//  YourSchool
//
//  Created by 임준협 on 2023/01/27.
//

import Foundation
import MapKit
import SwiftUI
import CoreLocation

struct MyMapView: UIViewRepresentable {
    let locationManager = CLLocationManager()
    func makeUIView(context: Context) -> some MKMapView {
        let mkMapView = MKMapView()
        mkMapView.delegate = context.coordinator
        self.locationManager.delegate = context.coordinator
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        mkMapView.showsUserLocation = true
        mkMapView.setUserTrackingMode(.follow, animated: true)
        return mkMapView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("...")
    }
    func makeCoordinator() -> MyMapView.Coordinator {
        return MyMapView.Coordinator(self)
    }
    class Coordinator: NSObject {
        var myMapView: MyMapView
        
        init(_ myMapView: MyMapView) {
            self.myMapView = myMapView
        }
    }
}

struct MyMapView_Previews: PreviewProvider{
    static var previews: some View {
        MyMapView()
    }
}
extension MyMapView.Coordinator : MKMapViewDelegate {
    
}
extension MyMapView.Coordinator : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lat = locations.first?.coordinate.latitude,
              let lon = locations.first?.coordinate.longitude else{
            return
        }
        print("lat: \(lat), lon: \(lon)")
    }
}
