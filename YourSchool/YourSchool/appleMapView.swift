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
    @State var showDirections = false
    @State var showDirectionsInfo = false
    @State var time: DateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
    @State var selection = 0
    @State var eta: Int = 0
    var body: some View{
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            VStack {
                NavMapView(eta: $eta, directions: $directions)
                    .edgesIgnoringSafeArea(.top)
                VStack{
                    Text("\(getETA())")
                        .font(.title3)
                        .padding()
                    Text("경로")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top)
                        .padding(.bottom, -50)
                    TabView{
                        ForEach(0..<self.directions.count, id: \.self) { i in
                            Button(action: {showDirectionsInfo.toggle()}, label: {
                                Text(self.directions[i])
                                    .padding()
                                    .foregroundColor(Color("scheme"))
                                    .background(Color("blackwhite"))
                                    .cornerRadius(20)
                            })
                            
                        }
                    }.tabViewStyle(PageTabViewStyle())
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
//                        .padding(.top, -90)
                }
            }
            
        }.onAppear{
            showDirectionsAuto()
            time = getTime()
        }
        .sheet(isPresented: $showDirectionsInfo){
            DestinationInfoView(directions: directions, showDirectionsInfo: $showDirectionsInfo)
        }
        
        
    }
    
    func showDirectionsAuto() {
        if directions.isEmpty{
            showDirections.toggle()
        }
    }

    func secToHMS(seconds: Int) -> [Int] {
        return [seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60]
    }

    func getTime() -> DateComponents{
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        return components
    }
    func getETA() -> String{
        var amOrPm = "오전"
        var eh = (time.hour)!+secToHMS(seconds: eta)[0]
        var em = (time.minute)!+secToHMS(seconds: eta)[1]
        var es = (time.second)!+secToHMS(seconds: eta)[2]
        if es > 60 {
            es = es - 60
            em = em + 1
        }
        if em > 60 {
            em = em - 60
            eh = eh + 1
        }
        if eh > 12 {
            eh = eh - 12
            amOrPm = "오후"
        }
        
        return "예상 도착시간: \(amOrPm) \(eh)시 \(em)분"
    }
}
struct DestinationInfoView: View {
    @State var directions: [String]
    @State var showDirections = false
    @State var eta: Int = 0
    @Binding var showDirectionsInfo: Bool
    var body: some View{
        VStack{
            Text("경로")
                .foregroundColor(.white)
                .font(.largeTitle)
                .bold()
                .padding(.top)
            
            ScrollView{
                VStack(alignment: .leading){
                    ForEach(0..<self.directions.count, id: \.self) { i in
                        Text(self.directions[i])
                            .fontWeight(.bold)
                            .padding()
                            .padding(.vertical, 20)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .font(.title)
                        
                        Divider()
                            .background(.gray)
                        
                        
                    }
                    
                    
                    
                }.onAppear{
                    showDirectionsAuto()
                }
            }
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .fill(.black)
                    .frame(width: 100000, height: 100)
                    .padding(.top, 30)
                    

                Button(action: {
                    showDirectionsInfo.toggle()
                }, label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.blue)
                            .frame(width: 300, height: 70)
                        HStack{
                            Text("확인")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }.foregroundColor(Color("scheme"))
                        
                    }
                    
                    //                .ignoresSafeArea()
                    
                })
            }
        }.background(.black)
            .ignoresSafeArea()
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
    @Binding var eta: Int
    @Binding var directions: [String]
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    func makeUIView(context: Context) -> MKMapView {
        
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
                eta = Int(route.expectedTravelTime)
                print("eta is")
                print("\(eta/60) min")
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
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Get current position
        let sourcePlacemark = MKPlacemark(coordinate: locations.last!.coordinate, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)

        // Get destination position
        let lat1: NSString = "36.333065000000005"
        let lng1: NSString = "127.34531979051518"
        let destinationCoordinates = CLLocationCoordinate2DMake(lat1.doubleValue, lng1.doubleValue)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinates, addressDictionary: nil)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

        // Create request
        let request = MKDirections.Request()
        request.source = sourceMapItem
        request.destination = destinationMapItem
        request.transportType = MKDirectionsTransportType.walking
        request.requestsAlternateRoutes = false
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let route = response?.routes.first {
                print("Distance: \(route.distance), ETA: \(route.expectedTravelTime)")
            } else {
                print("Error!")
            }
        }
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
