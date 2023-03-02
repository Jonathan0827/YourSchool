import Foundation
// MARK: -Meal
struct meal: Codable {
    let mealServiceDietInfo: [MealServiceDietInfo]
}

// MARK: - MealServiceDietInfo
struct MealServiceDietInfo: Codable {
    let row: [Row]?
}



// MARK: - Row
struct Row: Codable {
    let atptOfcdcScCode, atptOfcdcScNm, sdSchulCode, schulNm: String
    let mmealScCode, mmealScNm, mlsvYmd, mlsvFgr: String
    let ddishNm, orplcInfo, calInfo, ntrInfo: String
    let mlsvFromYmd, mlsvToYmd: String

    enum CodingKeys: String, CodingKey {
        case atptOfcdcScCode = "ATPT_OFCDC_SC_CODE"
        case atptOfcdcScNm = "ATPT_OFCDC_SC_NM"
        case sdSchulCode = "SD_SCHUL_CODE"
        case schulNm = "SCHUL_NM"
        case mmealScCode = "MMEAL_SC_CODE"
        case mmealScNm = "MMEAL_SC_NM"
        case mlsvYmd = "MLSV_YMD"
        case mlsvFgr = "MLSV_FGR"
        case ddishNm = "DDISH_NM"
        case orplcInfo = "ORPLC_INFO"
        case calInfo = "CAL_INFO"
        case ntrInfo = "NTR_INFO"
        case mlsvFromYmd = "MLSV_FROM_YMD"
        case mlsvToYmd = "MLSV_TO_YMD"
    }
}

