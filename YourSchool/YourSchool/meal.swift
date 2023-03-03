//
//  meal.swift
//  YourSchool
//
//  Created by 임준협 on 2023/01/26.
//

import SwiftUI
import Alamofire

struct mealView: View {
    @State var mealInfo = ""
    @State var mealDate = Date() {
        didSet(oldValue){
            print(mealInfo)
            returnMealData()
        }
    }
    @State var df = DateFormatter()
    let sDf = DateFormatter()
    @State var showMeal: Bool = false
    var body: some View {
        NavigationView{
            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height
                VStack{
                    HStack{
                        Text("급식정보")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Image(systemName: "fork.knife.circle.fill")
                            .font(.largeTitle)
                    }
                    .padding(.top)
                    ZStack{
                        VStack{
                            Text(sDf.string(from: mealDate))
                            if mealInfo.isEmpty {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .primary))

                            } else {
                                Text(mealInfo)
                                    .fontWeight(.bold)
                            }
                        }
                        Spacer()
                            .frame(height: h/3)
                    }
                    
                    //                .padding(.leading)
                    
                    DatePicker("날짜를 선택해주세요", selection: $mealDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                    Spacer()
                }.onChange(of: mealDate, perform: {_ in
                    returnMealData()
                })
            }
        }.onAppear{
            returnMealData()
            sDf.dateFormat = "yyyy년 MM일 dd일"
        }
//        .onTapGesture {
//                returnMealData()
//            }
    }
    func returnMealData() {
        mealInfo = "fetching"
        df.locale = Locale(identifier: "ko_kr")
        df.timeZone = TimeZone(abbreviation: "KST")
        df.dateFormat = "yyyyMMdd"
        let ymd = df.string(from: mealDate)
        let url = "https://open.neis.go.kr/hub/mealServiceDietInfo?Type=json&ATPT_OFCDC_SC_CODE=G10&SD_SCHUL_CODE=7451342&MLSV_YMD=\(ymd)"
        AF.request(url).responseJSON {(response) in
            guard let html = String(data: response.data!, encoding: .utf8) else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(meal.self, from: html.data(using: .utf8)!)
                print(data.mealServiceDietInfo.self[1].row?[0].ddishNm)
                var mealCache = data.mealServiceDietInfo.self[1].row?[0].ddishNm
                mealCache = mealCache?.replacingOccurrences(of: "<br/>", with:"\n")
                mealInfo = mealCache!
            } catch {
                mealInfo = "이 날에는 급식이 제공되지 않습니다."
                print(error)
            }
        }
    }
}

struct meal_Previews: PreviewProvider {
    static var previews: some View {
        mealView()
    }
}
