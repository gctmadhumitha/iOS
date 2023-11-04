
import Foundation
import UIKit

let array  = [3,4,6,9,2,1, 9,8,5,9]

let max  = 9
let count  = array.filter { $0 == max }.count
print("count n is \(count)")


let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
view.backgroundColor = UIColor.blue

UIView.animate(withDuration: 2.0, animations: {
    view.backgroundColor = UIColor.red
})


let button = UIButton(frame: CGRect(x:0, y:0, width:120, height:50))
button.backgroundColor = UIColor.cyan



class Person {
    
    private var firstName : String
    private var lastName: String
    private let id = UUID()
    
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    var description : String {
        return "\(firstName)\(lastName)"
    }
    
}

class Student : Person {
    
    private (set) var  age : Int
    
    init(firstName: String, lastName: String, age: Int){
        self.age = age
        super.init(firstName: firstName, lastName: lastName)
        
    }

}

func timeIntensiveTask() {
   var counter = 0
   for _ in 0..<1000000000 {
       counter += 1
   }
}


//if let input = readLine(), let value = Int(input){
//      i += value
//  }
//  

//  print(i)

//func merge(intervals  : [[Int]]) -> [[Int]] {
//    let sortedIntervals = intervals.sorted { x, y in
//        x[0] < y[0]
//    }
//    var result = [[Int]]()
//    result.append(sortedIntervals[0])
//    for item in 1..<sortedIntervals.count {
//        var rlast = result.count - 1
//        if result.last[1] > item[0] {
//            result[rlast][1] = max(item[1], result[rlast][1]!)
//        } else {
//            result.append(item)
//        }
//    }
//}


func queueTasks(){
//    DispatchQueue.main.async {
//        print("async started")
//        timeIntensiveTask()
//        print("async ended")
//     }
//     print("sync task started")
//     timeIntensiveTask()
//     print("sync task ended")
    
    print(" #0")
    DispatchQueue.main.async{
        print(" #1")
        DispatchQueue.global().sync{
            print(" #2")
            DispatchQueue.global().sync{
                print(" #6")
            }
            print(" #7")
        }
        print(" #4")
    }
    print(" #3 ")
//    DispatchQueue.main.async{
//        print("main async # 2")
//        
//    }
    
}

func newQueue(){
    print("0")
    DispatchQueue.global().async{
        print("1")

    }
    print("2")
    DispatchQueue.global().sync{
        sleep(1)
        print("3")
    }
}


//queueTasks()
print("Thread.isMainThread  \(Thread.isMainThread)")
//newQueue()



func queueBarrier() {
    let queue = DispatchQueue(label:"com.test", attributes: .concurrent)

    queue.async {
        for i in 0..<5 {
         sleep(1)
            print("queue async \(i)")
        }
    }

    queue.sync {
        for i in 0..<5 {
         sleep(1)
            print("queue sync \(i)")
        }
    }
}

//queueBarrier()


func splitBinaryString(str: String) -> Int {
    var numEqualstrings = 0
    var count = 0
    for ch in str {
        switch ch {
        case "0":
                count += 1
        case "1":
            count -= 1
        default:
            return -1
        }
        if count == 0 {
            numEqualstrings += 1
        }
    }
    return count != 0 ? -1 : numEqualstrings
}


func countWaysToClimb(n: Int) -> Int {
    guard n > 0 else {
        return -1
    }
    if n == 1 || n == 2 {
        return n
    }
    return countWaysToClimb(n: n-1) + countWaysToClimb(n: n-2)
}

let bstr = "000001111100000"

print("Number of substrings", splitBinaryString(str: bstr))
print ("Ways to climb ", countWaysToClimb(n: 4))


func fibonacci( n: Int) -> Int {
    if n == 0 || n == 1 {
        return n
    }
    return fibonacci(n: n-1) + fibonacci(n: n-2)
}
 

func binarySearch( numbers: [Int], number : Int , lBound: Int, uBound : Int ) -> Int {
    
    if ( uBound >= lBound) {
        let mid = lBound + Int((uBound - lBound) / 2)
        if number == numbers[mid] {
            return mid
        }
        if number < numbers[mid] {
            return binarySearch(numbers: numbers, number: number, lBound: lBound, uBound: mid - 1)
        }
        else{
            return binarySearch(numbers: numbers, number: number, lBound: mid + 1, uBound: uBound)
        }
    }
    return -1
}

let searchArray =  [4,5,6,7,0,1,2]   //[ 2, 3, 4, 10, 40 ]
let arrLength = searchArray.count;
let numToSearch = 0;
print("Binary Search :: ", binarySearch(numbers: searchArray, number: numToSearch, lBound: 0, uBound: arrLength - 1))


// not finished
func binarySearchRotatedArray( numbers: [Int], number : Int , lBound: Int, uBound : Int ) -> Int {
    
    print ( "uBound : \(uBound), lBound: \(lBound)")
    
    if ( uBound >= lBound) {
        let mid = lBound + Int((uBound - lBound) / 2)
        print("mid :\(mid) , number is\(number), numbers[mid] :\(numbers[mid])")
        if number == numbers[mid] {
            print("match \(mid)")
            return mid
        }
        if number < numbers[mid] {
            if numbers[lBound] > numbers[mid] {
                return binarySearchRotatedArray(numbers: numbers, number: number, lBound: lBound, uBound: mid - 1)
            }
        }
        else{
            return binarySearchRotatedArray(numbers: numbers, number: number, lBound: mid + 1, uBound: uBound)
        }
    }
    return -1
}


let boolArray = Array(repeating: true, count: 25)

let arra = [1,2,3,4,5,7]
for num in stride(from: arra.count, through: 0, by: -1){
    print("number is" , num)
}
    
 
let s1 = "carjabj"
let s2 = "acraabj"

var matchChars = s1.enumerated().filter { index, ch in
    return ch == s2[s2.index(s2.startIndex, offsetBy: index)]
}.count
    
print(matchChars)

// Assumptions : Int array
// Have to handle optionals

func isEvenOdd(numbers: [Int]) -> Bool {
    guard numbers.count > 0 else {
        return false
    }
    var level = 0
    var i = 0
    while i<numbers.count {
        var numberOfNodesAtLevel = power(value: 2, power: level)
        print("level ", level)
        print("numberOfNodesAtLevel ", numberOfNodesAtLevel)
        print("i is", i)
        var levelArray = [Int]()
        for j in i..<i+numberOfNodesAtLevel {
            levelArray.append(numbers[j])
        }
        print("levelArray is ", levelArray)
        if !isArrayValid(nums: levelArray, level: level){
            return false
        }
        else {
           level += 1
           i = i + numberOfNodesAtLevel
           print("new level " , level)
           print("new i ", i)
        }
    }
    return true
}


func isArrayValid(nums:[Int], level: Int) -> Bool{
    let isEven = (level%2 != 0) ? true : false
    for i in 0..<nums.count-1 {
        if isEven {
            if nums[i]%2 != 0 && nums[i] < nums[i+1]{
                return false
            }
        } else{
            if nums[i]%2 == 0  && nums[i] > nums[i+1]{
                return false
            }
        }
    }
   return true
}

func power(value: Int, power: Int) -> Int {
    var total = 1
    for _ in 0..<power {
        total *= value
    }
    return total
}

print("power is ", power(value: 2, power: 5))

let evenOddArray = [1,10,4,3,6,7,9]
print(isEvenOdd(numbers: evenOddArray))




func bestTimeToBuy( array: [Int])  {
    
    var lp = 0, rp = 0
    var maxProfit : Int = 0
    while rp < array.count {
        if array[lp] > array[rp]
        {
            lp = rp
        } else {
            let profit = array[rp] - array[lp]
            maxProfit = maxValue(num1: maxProfit, num2: profit)
            
        }
        rp += 1
  
    }
    print("Max Profit ::" , maxProfit)
    
}

func maxValue( num1: Int, num2: Int) -> Int {
    return num1 > num2 ? num1 : num2
}


func reconstructDigits(str: String ) {
    
    let characterDigitMap : [Character: Int] = ["z" : 0, "x" : 6 , "g" : 8, "w" : 2, "u" : 4,
                               "o" : 1, "f" : 5 , "h" : 3, "s" : 7, "i" : 9]
    var count = Array(repeating: 0, count: 10)
    guard str.count > 0 else {
        return
    }
    for ch in str {
        let value = characterDigitMap[ch]
        if let value = value {
           count[value] += 1
        }
    }
    let repeatingCharacters = ["o", "f", "h", "s", "i"]
    for ch in repeatingCharacters {
        switch ch {
        case "o":
            count[1] = count[1] - count[0] - count[2] - count[4]
        case "h":
            count[3] = count[3] - count[8]
        case "f":
            count[5] = count[5] - count[4]
        case "s":
            count[7] = count[7] - count[6]
        case "i":
            count[9] = count[9] - count[5] - count[6] - count[8]
        default:
            continue
        }
    }
    var result = [String]()
    for i in 0..<count.count {
        print("count\(i)" , count[i])
        var valCount = count[i]
        while valCount > 0 {
            result.append("\(i)")
            valCount -= 1
        }
    }
    print("Result is" , result)
}


print(reconstructDigits(str: "owoztneoeronesitheifournineghfivetsevenreex"))

func groupAnagrams(strs: [String]) -> [[String]]{
    var dictMap = [String: [String]]()
    
    for str in strs {
        var sortedStr = str.sorted()
        print("sorted str \(sortedStr)")
        var key = String(sortedStr)
        if dictMap[key] != nil {
            dictMap[key]?.append(str)
        }
        else {
            dictMap[key] = [str]
        }
    }
    var result = dictMap.map { (key, value) -> [String] in
        return value
        
    }
    return result
}


print("groupAnagrams " , groupAnagrams(strs: ["eat", "tea", "nat", "tan", "ate"]))


func countBinaryStrings(str: String) -> Int {
    var i = 0
    var curr = 1, prev = 0, count = 0
    while( i < str.count - 1 ) {
        let cindex = str.index(str.startIndex, offsetBy: i)
        let nindex = str.index(str.startIndex, offsetBy: i-1)
        if str[cindex] != str[nindex] {
            count += min(curr, prev)
            curr = prev
            curr = 1
        }else {
            curr += 1
        }
        i += 1
    }
    return count + min(curr, prev)
    
}


print(countBinaryStrings(str: "110011"))
