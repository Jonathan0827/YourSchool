//
//  Settings.swift
//  YourSchool
//
//  Created by 임준협 on 2023/03/01.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isFirstLaunching: Bool
    @Binding var userName: String
    @Binding var goReset: Bool
    var body: some View {
        VStack{
            Form {
//                Section{
//                    Button(action: {}, label: {
//                        HStack{
//                            Image(systemName: "info.circle.fill")
//                            Text("  정보")
//                        }
//                        .foregroundColor(.primary)
//                    })
//                }
                Section{
                    Button(action: {isFirstLaunching = true;userName = "";goReset = false}, label: {
                        HStack{
                            Image(systemName: "gear.badge.xmark")
                            Text("  초기화")
                        }
                        .foregroundColor(.red)
                    })
                }
            }
        }
    }
}
