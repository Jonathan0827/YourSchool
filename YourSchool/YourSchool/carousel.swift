//
//  carousel.swift
//  YourSchool
//
//  Created by 임준협 on 2023/01/25.
//

import SwiftUI

struct carousel: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            VStack{
                
                TabView {
                    Text("First")
                    Text("Second")
                    Text("Third")
                    Text("Fourth")
                }
                .frame(height: h/2)
                .tabViewStyle(.page)
                
                
                Text("hey")
            }
        }
    }
}

struct carousel_Previews: PreviewProvider {
    static var previews: some View {
        carousel()
    }
}
