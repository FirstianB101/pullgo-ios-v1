import Foundation

func solution(_ new_id:String) -> String {
    
    var rec_id = new_id
    // step 1
    rec_id = rec_id.lowercased()
    // step 2
    rec_id = rec_id.filter { $0.isLowercase || $0.isNumber || $0 == "-" || $0 == "_" || $0 == "." }
    // step 3
    rec_id = rec_id.removeDuplicateDot()
    // step 4
    if rec_id.first == "." {
        rec_id.removeFirst()
    } else if rec_id.last == "." {
        rec_id.removeLast()
    }
    // step 5
    if rec_id.isEmpty { rec_id = "a" }
    // step 6
    if rec_id.count >= 16 {
        rec_id.removeLast(rec_id.count - 15)
        if rec_id.last == "." {
            rec_id.removeLast()
        }
    }
    // step 7
    if rec_id.count <= 2 {
        let last = rec_id.removeLast()
        repeat {
            rec_id.append(last)
        } while rec_id.count < 3
    }
    
    return rec_id
}

extension String {
    func removeDuplicateDot() -> String {
        var result = ""
        let str = self.map { $0 }
        
        for i in 0 ..< self.count {
            if str[i] != "." {
                result.append(str[i])
            } else if str[i] == "." && i + 1 < self.count {
                if str[i + 1] != "." {
                    result.append(str[i])
                }
            }
        }
        
        return result
    }
}

print(solution("...!@BaT#*..y.abcdefghijklm"))
