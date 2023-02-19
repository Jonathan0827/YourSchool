//import Combine
import CoreLocation
//
//final class DeviceLocationService: NSObject, CLLocationManagerDelegate, ObservableObject {
//
//    var coordinatesPublisher = PassthroughSubject<CLLocationCoordinate2D, Error>()
//    var deniedLocationAccessPublisher = PassthroughSubject<Void, Never>()
//
//    private override init() {
//        super.init()
//    }
//    static let shared = DeviceLocationService()
//
//    private lazy var locationManager: CLLocationManager = {
//        let manager = CLLocationManager()
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//        manager.delegate = self
//        return manager
//    }()
//
//    func requestLocationUpdates() {
//        switch locationManager.authorizationStatus {
//
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//
//        case .authorizedWhenInUse, .authorizedAlways:
//            locationManager.startUpdatingLocation()
//
//        default:
//            deniedLocationAccessPublisher.send()
//        }
//    }
//
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        switch manager.authorizationStatus {
//
//        case .authorizedWhenInUse, .authorizedAlways:
//            manager.startUpdatingLocation()
//
//        default:
//            manager.stopUpdatingLocation()
//            deniedLocationAccessPublisher.send()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print(locations)
//        guard let location = locations.last else { return }
//        coordinatesPublisher.send(location.coordinate)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        coordinatesPublisher.send(completion: .failure(error))
//    }
//}
//import Foundation
//import CoreLocation
//import MapKit
//
//final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private let locationManager = CLLocationManager()
//
//
//    override init() {
//        super.init()
//        locationManager.delegate = self
//    }
//
//    func requestLocation() {
//        locationManager.requestLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else { return }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        //Handle any errors here...
//        print (error)
//    }
//}
//import Foundation
//import CoreLocation
//import MapKit
//
//final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private let locationManager = CLLocationManager()
//
//    @Published var location: CLLocationCoordinate2D?
//    @Published var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 42.0422448, longitude: -102.0079053),
//        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
//    )
//
//    override init() {
//        super.init()
//        locationManager.delegate = self
//    }
//
//    func requestLocation() {
//        locationManager.requestLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else { return }
//
//        DispatchQueue.main.async {
//            self.location = location.coordinate
//            self.region = MKCoordinateRegion(
//                center: location.coordinate,
//                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
//            )
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        //Handle any errors here...
//        print (error)
//    }
//}

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    
    private let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
}
