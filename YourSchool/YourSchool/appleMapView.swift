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
    @State var locationManager: CLLocationManager!
    @State var crntLat: String?
    @State var crntLon: String?
    @State var schoolPosition = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36.333065000000005, longitude: 127.34531979051518), span: MKCoordinateSpan())
    var pinAnnotation = MKPointAnnotation()
//    pinAnnotation.coordinate = schoolPosition
    @State private var pins: [pin] = [
        pin(coordinate: .init(latitude: 36.333065000000005, longitude: 127.34531979051518))
        ]

        @State private var userTrackingMode: MapUserTrackingMode = .follow


        var body: some View {
            Map(coordinateRegion: $schoolPosition, annotationItems: pins) { pin in
                MapAnnotation(
                    coordinate: pin.coordinate,
                    anchorPoint: CGPoint(x: 0.43, y: 1.1)
                ) {
                    VStack{
                        HStack{
                            Text("학교")
                            Image(systemName: "arrow.down.circle.fill")
                        }
                        Circle()
                            .fill(Color(hue: 1.0, saturation: 0.886, brightness: 0.872, opacity: 0.359))
                            .frame(width: 60, height: 40)
                    }
                }
            }.edgesIgnoringSafeArea(.top)
        }
    
}

struct AppleMapView_Previews: PreviewProvider {
    static var previews: some View {
        AppleMapView()
    }
}
