//
//  ContentView.swift
//  YourSchool
//
//  Created by 임준협 on 2023/01/24.
//
//edu office code: G10
//School code: 7451342
//meal api link sample: https://open.neis.go.kr/hub/mealServiceDietInfo?Type=json&ATPT_OFCDC_SC_CODE=G10&SD_SCHUL_CODE=7451342&MLSV_YMD=20230303
//time table api sample: https://open.neis.go.kr/hub/misTimetable?ATPT_OFCDC_SC_CODE=G10&SD_SCHUL_CODE=7451342&TI_FROM_YMD=20230302&TI_TO_YMD=20230303
import SwiftUI
import Alamofire
import CenteredCollectionView
import Foundation
import WebKit
extension Date {
    var Tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    var DayAfterTomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    var Yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
}
struct ContentView: View {
    @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
    var body: some View{
        TabView{
            HomeView()
                .tabItem({Image(systemName: "building.columns.circle");Text("Home")})
            goingToSchoolView()
                .tabItem({Image(systemName: "map.circle");Text("Map")})
        }.fullScreenCover(isPresented: $isFirstLaunching) {
            OnboardingView(isFirstLaunching: $isFirstLaunching)
        }
        .onAppear{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "mm"
            print(Date().startOfWeek)
            print(Date().endOfWeek)
        }
    }
    
    
}
struct HomeView: View {
    @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
    @AppStorage("userName") var userName: String = ""
    @State var mealToday = "Fetching"
    @State var mealTomorrow = "Fetching"
    @State var mealDayAfterTomorrow = "Fetching"
    @State var mealYesterday = "Fetching"
    @State var mealSelection = 1
    @State var goReset = false
//    let date = Date()
    let session: URLSession = URLSession.shared

    var body: some View {
        NavigationView{
            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height
                VStack{
                    NavigationLink(destination: mealView(), label: {
                        TabView(selection: $mealSelection) {
                            VStack{
                                Text("어제 급식")
                                    .font(.title2)
                                    .fontWeight(.heavy)
                                Text(mealYesterday)
                                    .fontWeight(.bold)
                            }
                            .padding(h/15)
                            .foregroundColor(Color("scheme"))
                            .background(Color("blackwhite"))
                            .cornerRadius(20)
                            .tag(0)
                            VStack{
                                Text("오늘 급식")
                                    .font(.title2)
                                    .fontWeight(.heavy)
                                    .padding(.horizontal)
                                Text(mealToday)
                                    .fontWeight(.bold)
                            }
                            .padding(h/15)
                            .foregroundColor(Color("scheme"))
                            .background(Color("blackwhite"))
                            .cornerRadius(20)
                            .tag(1)
                            VStack{
                                Text("내일 급식")
                                    .font(.title2)
                                    .fontWeight(.heavy)
                                Text(mealTomorrow)
                                    .fontWeight(.bold)
                            }
                            .padding(h/15)
                            .foregroundColor(Color("scheme"))
                            .background(Color("blackwhite"))
                            .cornerRadius(20)
                            .tag(2)
                            VStack{
                                Text("내일 모래 급식")
                                    .font(.title3)
                                    .fontWeight(.heavy)
                                Text(mealDayAfterTomorrow)
                                    .fontWeight(.bold)
                            }
                            .padding(h/15)
                            .foregroundColor(Color("scheme"))
                            .background(Color("blackwhite"))
                            .cornerRadius(20)
                            .tag(3)
                            
                        }
                        .frame(height: h/2)
                        .tabViewStyle(PageTabViewStyle())
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    })
                    NavigationLink(destination: SettingsView(isFirstLaunching: $isFirstLaunching, userName: $userName, goReset: $goReset), isActive: $goReset, label: {})
                }
            }.onAppear(perform: {returnMealData()})
                .navigationBarTitle("안녕하세요, \(userName)님")
                .navigationBarItems(trailing:
                                        Button(action: {goReset = true}, label: {
                    Image(systemName: "gear.circle.fill")
                        .foregroundColor(Color("blackwhite"))
                })
                    
                )

//                .navigationTitle(ymdstr())
        }
    }
    func ymdData(ymd: String, tyd: String) -> String {
        df.locale = Locale(identifier: "ko_kr")
        df.timeZone = TimeZone(abbreviation: "KST")
        var date = Date()
        if tyd == "today"{
            date = Date()
        } else if tyd == "yesterday"{
            date = Date().Yesterday
        } else if tyd == "tomorrow"{
        } else if tyd == "dayafter" {
        }
        var ymdvalue = ""
        if ymd == "y"{
            df.dateFormat = "yyyy"
            ymdvalue = df.string(from: date)
        } else if ymd == "m"{
            df.dateFormat = "dd"
            ymdvalue = df.string(from: date)
        } else if ymd == "d"{
            df.dateFormat = "dd"
            ymdvalue = df.string(from: date)
        } else if ymd == "yyyymmdd" {
            df.dateFormat = "yyyymmdd"
            ymdvalue = df.string(from: date)
        } else{
            df.dateFormat = "yyyy"
            let y = df.string(from: date)
            df.dateFormat = "mm"
            let m = df.string(from: date)
            df.dateFormat = "dd"
            let d = df.string(from: date)
            ymdvalue = "\(y)년 \(m)월 \(d)일"
        }
        return ymdvalue
    }
    func returnMealData() {
        df.locale = Locale(identifier: "ko_kr")
        df.timeZone = TimeZone(abbreviation: "KST")
        df.dateFormat = "yyyyMMdd"
        let ymdSub = df.string(from: date)
        let ymd = Int(ymdSub)!
//        let ymd = 20220307 // test var
        print(ymd)
        var _ymdYesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        var _ymdTomorrow = Calendar.current.date(byAdding: .day, value: +1, to: Date())!
        var _ymdDayAfter = Calendar.current.date(byAdding: .day, value: +2, to: Date())!
        let ymdYesterday = df.string(from: _ymdYesterday)
        let ymdTomorrow = df.string(from: _ymdTomorrow)
        let ymdDayAfter = df.string(from: _ymdDayAfter)
        let urlToday = "https://open.neis.go.kr/hub/mealServiceDietInfo?Type=json&ATPT_OFCDC_SC_CODE=G10&SD_SCHUL_CODE=7451342&MLSV_YMD=\(ymd)"
        let urlTomorrow = "https://open.neis.go.kr/hub/mealServiceDietInfo?Type=json&ATPT_OFCDC_SC_CODE=G10&SD_SCHUL_CODE=7451342&MLSV_YMD=\(ymdTomorrow)"
        let urlYesterday = "https://open.neis.go.kr/hub/mealServiceDietInfo?Type=json&ATPT_OFCDC_SC_CODE=G10&SD_SCHUL_CODE=7451342&MLSV_YMD=\(ymdYesterday)"
        let urlDayAfterTomorrow = "https://open.neis.go.kr/hub/mealServiceDietInfo?Type=json&ATPT_OFCDC_SC_CODE=G10&SD_SCHUL_CODE=7451342&MLSV_YMD=\(ymdDayAfter)"
        AF.request(urlToday).responseJSON {(response) in
            guard let html = String(data: response.data!, encoding: .utf8) else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(meal.self, from: html.data(using: .utf8)!)
                print(data.mealServiceDietInfo.self[1].row?[0].ddishNm)
                var mealCache = data.mealServiceDietInfo.self[1].row?[0].ddishNm
                mealCache = mealCache?.replacingOccurrences(of: "<br/>", with:"\n")
                mealToday = mealCache!
            } catch {
                mealToday = "급식 없음"
                print(error)
            }
        }
        AF.request(urlTomorrow).responseJSON {(response) in
            guard let html = String(data: response.data!, encoding: .utf8) else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(meal.self, from: html.data(using: .utf8)!)
                print(data.mealServiceDietInfo.self[1].row?[0].ddishNm)
                var mealCache = data.mealServiceDietInfo.self[1].row?[0].ddishNm
                mealCache = mealCache?.replacingOccurrences(of: "<br/>", with:"\n")
                mealTomorrow = mealCache!
            } catch {
                mealTomorrow = "급식 없음"
                print(error)
            }
        }
        AF.request(urlDayAfterTomorrow).responseJSON {(response) in
            guard let html = String(data: response.data!, encoding: .utf8) else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(meal.self, from: html.data(using: .utf8)!)
                print(data.mealServiceDietInfo.self[1].row?[0].ddishNm)
                var mealCache = data.mealServiceDietInfo.self[1].row?[0].ddishNm
                mealCache = mealCache?.replacingOccurrences(of: "<br/>", with:"\n")
                mealDayAfterTomorrow = mealCache!
            } catch {
                mealDayAfterTomorrow = "급식 없음"
                print(error)
            }
        }
        AF.request(urlYesterday).responseJSON {(response) in
            guard let html = String(data: response.data!, encoding: .utf8) else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(meal.self, from: html.data(using: .utf8)!)
                print(data.mealServiceDietInfo.self[1].row?[0].ddishNm)
                var mealCache = data.mealServiceDietInfo.self[1].row?[0].ddishNm
                mealCache = mealCache?.replacingOccurrences(of: "<br/>", with:"\n")
                mealYesterday = mealCache!
            } catch {
                mealYesterday = "급식 없음"
                print(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 2, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 6, to: sunday)
    }
}

