import Foundation

func test(_ values: Int ...) {
    for value in values {
        print(value)
    }
}


test(1, 2, 3)
