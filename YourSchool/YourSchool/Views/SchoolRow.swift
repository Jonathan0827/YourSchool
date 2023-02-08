//
//  SchoolRow.swift
//  YourSchool
//
//  Created by 임준협 on 2023/01/26.
//

import SwiftUI

struct SchoolRow: View {
    var school: School

        var body: some View {
            Text("Hello, World!")
        }
}

struct SchoolRow_Previews: PreviewProvider {
    static var previews: some View {
        SchoolRow(school: schools[0])
    }
}
