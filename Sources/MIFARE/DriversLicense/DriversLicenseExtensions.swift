//
//  DriversLicenseExtensions.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/07.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_MIFARE)
import TRETJapanNFCReader_MIFARE
#endif

@available(iOS 13.0, *)
internal extension Optional where Wrapped == String {
    init(jisX0208Data: [[UInt8]]) {
        self = jisX0208Data.map { (data) -> String in
            let bytes = UInt16(data[1]) << 8 + UInt16(data[0])
            if bytes >= 0xF1FF {
                return "○"
            } else {
                let data = (bytes + 0x8080).data
                if let s = String(data: data, encoding: .japaneseEUC) {
                    return s
                } else {
                    return "○"
                }
            }
        }.joined()
    }
    
    func toDateFromJapanese() -> Date? {
        if var dateString = self {
            // 明治=1, 大正=2, 昭和=3, 平成=4, 令和=5
            switch dateString.first {
            case "1":
                dateString = "明治" + dateString.dropFirst()
            case "2":
                dateString = "大正" + dateString.dropFirst()
            case "3":
                dateString = "昭和" + dateString.dropFirst()
            case "4":
                dateString = "平成" + dateString.dropFirst()
            case "5":
                dateString = "令和" + dateString.dropFirst()
            default:
                break
            }
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ja")
            formatter.calendar = Calendar(identifier: .japanese)
            formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
            formatter.dateFormat = "GyyMMdd"
            
            let date = formatter.date(from: dateString)
            return date
        }
        return nil
    }
}

