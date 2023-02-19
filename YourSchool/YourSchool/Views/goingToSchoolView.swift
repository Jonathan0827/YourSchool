//
//  goingToSchoolView.swift
//  YourSchool
//
//  Created by 임준협 on 2023/01/26.
//

import SwiftUI
import MapKit
import CoreLocation
struct goingToSchoolView: View {
    var body: some View {
        NavigationView{
            VStack{
                MapView(coordinate: CLLocationCoordinate2D(latitude: 36.333065000000005, longitude: 127.34531979051518))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .frame(height:300)
                
                VStack(alignment: .leading){
                    Text("학교 🏫")
                        .font(.title)
                    HStack{
                        Text("원신흥중학교")
                        Spacer()
                        Text("대전광역시 유성구 동서대로 735번길 20")
                            .font(.subheadline)
                    }
                }
                .padding()
                NavigationLink(destination: AppleMapView(), label: {
                    HStack{
                        Text("길안내 시작")
                        Image(systemName: "arrow.right.circle.fill")
                    }
                    .padding()
                    
                })
                .foregroundColor(Color("scheme"))
                .background(.primary)
                .cornerRadius(20)
                
            }.padding(.top, -100.0)
            .navigationBarTitle("학교 길안내")
        }
    }
}

struct MapView: View {
    var coordinate: CLLocationCoordinate2D
    @State private var region = MKCoordinateRegion()
    var body: some View{
        Map(coordinateRegion: $region)
            .onAppear {
                setRegion(coordinate)
            }
    }
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
            region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
            )
        }
}
struct goingToSchoolView_Previews: PreviewProvider {
    static var previews: some View {
        goingToSchoolView()
        MapView(coordinate: CLLocationCoordinate2D(latitude: 36.333065000000005, longitude: 127.34531979051518))
    }
}
