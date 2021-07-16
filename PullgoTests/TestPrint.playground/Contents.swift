import Foundation

extension Date {
    func toKST() -> Date {
        return date.addingTimeInterval(9 * 3600)
//        let date = DateFormatter()
//
//        date.locale = Locale(identifier: "ko_KR")
//        date.timeZone = TimeZone(identifier: "ko_KR")
//        date.dateFormat = "YYYY-MM-dd"
//
//        let kst = date.string(from: self)
//        return date.date(from: kst)!
    }
}

let date = Date()
print(date)
print(date.toKST())
