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
    @Binding var rnum: Int
    @AppStorage("rainBar") var rainBar: Bool = true

    let num = Int.random(in: 0...5)
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
        .onAppear{
            if rainBar{
                rnum = num
            } else {
                rnum = 0
            }        }
    }
}

struct MapView: View {
    var coordinate: CLLocationCoordinate2D
    @State private var region = MKCoordinateRegion()
    var body: some View{
        Map(coordinateRegion: $region, interactionModes: [])
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
