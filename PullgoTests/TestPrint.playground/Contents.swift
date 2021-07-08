let word = "ljes=njak".map { $0 }

let croatian: [String] = ["c=", "c-", "dz=", "d-", "lj", "nj", "s=", "z="]
let croatianStart: [String] = ["c", "d", "l", "n", "s", "z"]

func process() -> Int {
    var result = 0
    var i = 0
    
    repeat {
        var check: String = ""
        var w = word[i]

        if croatianStart.contains(String(w)) {
            check.append(w)
            i += 1

            if i == word.count { result += 1; break }

            w = word[i]
            check.append(w)

            if check == "dz" {
                i += 1
                if i == word.count { result += 2; break }
                w = word[i]
                check.append(w)

                if check == "dz=" { result += 1 }
                else { result += 3 }

            } else {
                if croatian.contains(check) {
                    result += 1
                } else {
                    result += 2
                }
            }

        } else {
            result += 1
        }
        
        i += 1
    } while i < word.count

    return result
}

print(process())
