import UIKit
import Foundation
var greeting = "Hello, playground"


/// Main Program
func main() {
    print(" #1. countConsistentStrings")
    
    let word = "abc", words = ["a","b","ce","ab","ac","bc","abc", "abcd"]
    print("Input word \(word) , sentence \(words)")
    print("Output :: ", countConsistentStrings(word: word, words: words))
    
    
    print("#2. uniqueEmailAddress")
    
    let emails = ["test.email+alex@leetcode.com","test.e.mail+bob.cathy@leetcode.com","testemail+david@lee.tcode.com"]
    
    print("Input - \(emails)")
    print("Output :: ", uniqueEmailAddress(emails: emails))
    
    let nums = [1,22,8,4,5,6,8,2,14,4,19]
    print("Remove val :: ", removeElement(nums: nums, val: 8))
    
    let getCharacterCountStr = "aabbaddnnnccc"
    print("getCharacterCount ", getCharacterCount(str:getCharacterCountStr))
    
    let validParanthesisStr = "{}{}[()]"
    print("isValidParenthesis", isValidParenthesis(str: validParanthesisStr))
    
    
    let heightStairs = 5
    print("Climb Stairs ", climbStairs(height: heightStairs))
    
    print("Climb Stairs DP", climbStairsDP(height: heightStairs))
    
}


func other(){
    // Creating a dictionary
    var dict = [3: "car", 4: "bike", 19: "bus", 2: "train"]
    
    print("Original Dictionary:", dict)
    
    // Update a key-Value pair
    dict.updateValue("aeroplane", forKey: 7)
    
    // Displaying output
    print("Updated Dictionary:", dict)
}


/// Problem#1 - countConsistentStrings
func countConsistentStrings(word: String, words: [String]) -> Int {
    
    var count = words.count
    guard word.count > 0 && words.count > 0 else{
        return 0
    }
    var letterMap = [Character : Int]()
    /// Create a Hash Map of the letters of the allowed word
    for letter in word {
        letterMap.updateValue(1, forKey: letter)
    }
    
    /// Iterate through each word to check if it has only the letters from the allowed word
    for word in words {
        for letter in word {
            if letterMap[letter] == nil {
                count -= 1
                break
            }
        }
    }
    return count
    
}


/*
 Problem #2 :
 
 https://leetcode.com/problems/unique-email-addresses/
 
 Input: emails = ["test.email+alex@leetcode.com","test.e.mail+bob.cathy@leetcode.com","testemail+david@lee.tcode.com"]
 Output: 2
 Explanation: "testemail@leetcode.com" and "testemail@lee.tcode.com" actually receive mails.
 
 ##Assumption - The emails are valid
 
 */
func uniqueEmailAddress(emails : [String]) -> [String]{
    var uniqueEmails = [String: Int]()
    
    for var email in emails {
        var emailFirst = email.split(separator: "@").first
        let emailLast = email.split(separator: "@").last
        // check - 1 test.email+alex
        let plusIndex = email.firstIndex(of: "+")
        if let plusIndex = plusIndex, var emailFirst = emailFirst, let emailLast = emailLast {
            emailFirst = email[..<plusIndex]
            // check - 2 test.e.mail+bob
            emailFirst.removeAll(where: { $0 == "."
            })
            email = "\(emailFirst)@\(emailLast)"
            
            if var uEmail = uniqueEmails[email] {
                uEmail += uEmail + 1
            } else {
                uniqueEmails[email] = 1
            }
        }
    }
    return Array(uniqueEmails.keys)
}



func removeElement(nums: [Int], val: Int) -> [Int]{
    return nums.filter({ value in
        value != val
    })
}



func getCharacterCount(str: String) -> String {
    var charactersDict = [Character:Int]()
    var result = ""
    for s in str {
        if let ch = charactersDict[s] {
            charactersDict[s] = ch + 1
        } else {
            charactersDict[s] = 1
        }
    }
    for key in charactersDict.keys  {
        result += "\(charactersDict[key]!)\(key)"
    }
    return result
}


extension String {
    
    subscript(i: Int) -> Character {
        let index = self.index(self.startIndex, offsetBy: i)
        return self[index]
    }
    
}

struct Stack<T> : CustomStringConvertible {
    
    private var items:[T] = []
    
    //push
    mutating func push(element: T){
        items.append(element)
    }
    
    //pop
    mutating func pop() -> T? {
        guard items.count > 0 else {
            return nil
        }
        return items.removeLast()
    }
    
    //peek
    func peek() -> T? {
        guard items.count > 0 else {
            return nil
        }
        return items.last
    }
    
    var count : Int {
        return items.count
    }
    
    var description: String {
        let top = "\nStack\n"
        let items = items.map{ String(describing:$0) }.reversed().joined(separator: "\n")
        return top + items + "\n"
    }
}

func isValidParenthesis(str: String) -> Bool {
    var paranthesis = Stack<Character>()
    print("input string is ", str)
    for ch in str {
        print("ch is ", ch)
        print("paranthesis.description ", paranthesis.description)
        print("count is ", paranthesis.count)
        switch ch {
        case "(":
            paranthesis.push(element: ")")
        case "{":
            paranthesis.push(element: "}")
        case "[":
            paranthesis.push(element: "]")
        default:
            let element = paranthesis.pop()
            if element != ch {
                return false
            }
        }
    }
    return true
}


func climbStairs(height: Int )-> Int {
    
    var one = 1
    var two = 1
    var index = 0
    while index < height-1 {
        var temp = two
        two = one + two
        one = temp
        index += 1
    }
    return two
}


func climbStairsDP(height: Int) -> Int {
    var dp: [Int] = Array(repeating: 0, count: height)
    dp[0] = 1
    dp[1] = 2
    var i = 2
    for i in 2..<height {
        print("i is ", i)
        dp[i] = dp[i-1] + dp[i-2]
    }
    return dp[height-1]
}


class TreeNode <T> {
    var value : T
    var left: TreeNode<T>?
    var right: TreeNode<T>?
    
    init(value: T, left:TreeNode<T>? = nil, right: TreeNode<T>? = nil ){
        self.value = value
        self.left = left
        self.right = right
    }
    
}


class BinarySearchTree<T: Comparable & CustomStringConvertible> {
    private var root : TreeNode<T>?
    
    func insert(value: T){
        let node = TreeNode(value:value)
        if let root = root {
            self.insertNode(node: node, current: root)
        }else{
            root = node
        }
    }
    
    func insertNode(node: TreeNode<T>, current: TreeNode<T>){
        if node.value <= current.value {
            if current.left == nil {
                current.left = node
            }else{
                insertNode(node: node, current: current.left!)
            }
        }
        else if node.value > current.value {
            if current.right == nil {
                current.right = node
            }else {
                insertNode(node: node, current: current.right!)
            }
        }
    }
    
    func inOrderTraversal(node:TreeNode<T>?){
        guard let node = node else {
            return
        }
        inOrderTraversal(node: node.left)
        print(node.value)
        inOrderTraversal(node: node.right)
        
    }
    
    func preOrderTraversal(node:TreeNode<T>?){
        guard let node = node else {
            return
        }
        print(node.value)
        preOrderTraversal(node: node.left)
        preOrderTraversal(node: node.right)
        }
    
    func traverse(){
        inOrderTraversal(node: root)
        print("Pre-order traversal")
        preOrderTraversal(node: root)
    }
    
    func lowestCommonAncestor(p: TreeNode<T>?, q: TreeNode<T>?) -> TreeNode<T>? {
        guard let _ = root, let p = p, let q = q else {
            return nil
        }
        var current = root
        while(current != nil) {
            if p.value < current!.value && q.value < current!.value {
                current = current!.left
            }else if p.value > current!.value && q.value > current!.value {
                current = current!.right
            }else{
                return current
            }
        }
        return nil
    }

    func lowestCommonAncestorRecursion(root: TreeNode<T>?, p: TreeNode<T>?, q: TreeNode<T>?) -> TreeNode<T>? {
        guard let root = root, let p = p, let q = q  else {
            return nil
        }
        if p.value < root.value && q.value < root.value {
            return lowestCommonAncestorRecursion(root: root.left, p: p, q: q)
        }else if p.value > root.value && q.value > root.value {
            return lowestCommonAncestorRecursion(root: root.right, p: p, q: q)
        }else{
            return root
        }
    }
    
    
    func lcaRecursion(p: TreeNode<T>?, q: TreeNode<T>?) -> TreeNode<T>? {
        return lowestCommonAncestorRecursion(root: root, p: p, q: q)
    }
}



func tree()
{
    let tree1 = BinarySearchTree<Int>()
    tree1.insert(value: 1)
    tree1.insert(value: 2)
    tree1.insert(value: 3)
    tree1.insert(value: 4)
    tree1.insert(value: 5)
    tree1.insert(value: 6)
    tree1.insert(value: 7)
    tree1.insert(value: 8)
    
    tree1.traverse()
    
    
    let tree = BinarySearchTree<String>()
    tree.insert(value: "F")
    tree.insert(value: "G")
    tree.insert(value: "H")
    tree.insert(value: "D")
    tree.insert(value: "E")
    tree.insert(value: "I")
    tree.insert(value: "J")
    tree.insert(value: "A")
    tree.insert(value: "B")
    tree.insert(value: "C")
    
    tree.traverse()
    print("lowestCommonAncestor   " , tree.lowestCommonAncestor(p: TreeNode(value: "H"), q: TreeNode(value: "E"))?.value)
    print("lowestCommonAncestor   " , tree.lcaRecursion( p: TreeNode(value: "H"), q: TreeNode(value: "E"))?.value)
}


func generateBeautifulStrings(size: Int) -> [String] {
    guard size > 0 else {
        fatalError("Incorrect size")
    }
    var zeroString = "0"
    var oneString = "1"
    
    for i in 1..<size {
        let flag = i%2 == 0 ? true:false
        zeroString += flag ? "0" : "1"
        oneString += flag ? "1" : "0"
    }
    return [zeroString, oneString]
}

func diffStrings(str1: String, str2: String) -> Int {
    if str1 == str2 {
        return 0
    }
    
    let char1 = str1.components(separatedBy: "")
    let char2 = str2.components(separatedBy: "")
    let difference = zip(char1, char2).filter { $0 != $1
        
    }.count
         
    print("difference is between\(str1) and \(str2)", difference)
    
    return 0
}

//main()



tree()
diffStrings(str1: "100001", str2: "101010")
print("generateBeautifulStrings" , generateBeautifulStrings(size: 5))


let wizards2 = ["Harry", "Ron", "Hermione", "Draco"]
let animals2 = ["Hedwig", "Scabbers", "Crookshanks"]

print(zip(wizards2, animals2) )

for (wizard, animal) in zip(wizards2, animals2) {
    print("\(wizard) has \(animal)")
}



func rotateArray( nums: inout [Int], k: Int) {
    let halfLength = (nums.count - 1 ) / 2
    print("halfLength ", halfLength)
    
    //reversing
    for i in 0...halfLength  {
        print("swaping \(i) with \(nums.count - 1 - i)")
        var temp = nums[i]
        nums[i] = nums[nums.count - 1 - i]
        nums[nums.count - 1 - i] = temp
    }
    let swaplengthForFirstHalf = k/2
    let swaplengthForSecondHalf = (nums.count  - k - 1)/2
    print("swaplengthForFirstHalf ", swaplengthForFirstHalf)
    print("swaplengthForSecondHalf" , swaplengthForSecondHalf)
    print("after reversing" , nums)
    for i in 0..<swaplengthForFirstHalf {
        var temp = nums[i]
        nums[i] = nums[k - 1 - i]
        nums[k - 1 - i] = temp
    }
    print("after swapping first half ", nums)
    for i in 0..<swaplengthForSecondHalf {
        var temp = nums[k+i]
        nums[k+i] = nums[nums.count - 1 - i]
        nums[nums.count - 1 - i ] = temp
    }
    print("after swapping second half ", nums)
    print("reversed string is ", nums)
}
var n = [1,2,3,4,5,6,7]
print(rotateArray(nums: &n, k: 2))


// nums  = [1,2,3,4,5,6,7]
// position = 3
// subarray to be reversed = [5,6,7]
func reverseArray (nums: inout [Int], position: Int){
    let reverseSubArrayLength = nums.count - position - 1 // 7 - 3 - 1= 3
    let reverseSubArrayStartIndex = position + 1 // 3 + 1 = 4 , [5]
    
    for i in 0..<reverseSubArrayLength/2 // 0 to < (3/2 = 1) // only 0
    {
        // pass i = 0, swap nums[6] and nums[4]
        var temp = nums[reverseSubArrayStartIndex + i]// nums[7-1-0] = nums[6]
        nums[reverseSubArrayStartIndex + i] = nums[nums.count-1-i] // nums[4]
        nums[nums.count-1-i] = temp
    }
    print("Reversed Array is ", nums)
}
var n1 = [1,2,3,4,5,6,7]
print(reverseArray(nums: &n1, position: 3))


func setZeroes(matrix: inout [[Int]]) {
    let rowsize = matrix.count
    let columnSize = matrix[0].count
    var firstRow = false
    var firstColumn = false
    for i in 0..<rowsize {
        for j in 0..<columnSize {
            if matrix[i][j] == 0 {
                if i == 0 {
                    firstRow = true
                }
                if j == 0 {
                    firstColumn = true
                }
                matrix[i][0] = 0
                matrix[0][j] = 0
            }
        }
    }
    
    for i in 1..<rowsize {
        for j in 1..<columnSize {
            if matrix[i][0] == 0 || matrix[0][j] == 0{
                matrix[i][j] = 0
            }
        }
    }
    
    if firstRow {
        for i in 0..<columnSize {
            matrix[0][i] = 0
        }
    }
    
    if firstColumn {
        for i in 0..<rowsize {
            matrix[i][0] = 0
        }
    }
    
    print("Zero matrix" , matrix)
}


var matrix = [[0,1,2,0], [3,4,0,2], [1,3,1,5]]

setZeroes(matrix: &matrix)


class Node<T> {
    var value: T?
    var next: Node<T>?
    
    init(value: T, next: Node<T>? = nil ){
        self.value = value
        self.next = next
    }
}

class LinkedList<T> {
    
    private var root : Node<T>?
    private var last : Node<T>?
    
    init(node: Node<T>){
        self.root = node
    }
    
    func append(element: T){
        let newNode = Node(value: element, next: nil)
        if(root == nil)
        {
            root = newNode
            return
        }
        var current = root
        while(current?.next != nil) {
            current = current?.next
        }
        current?.next = newNode
    }
    
    func removeLastAndMakeItRoot(){
    
        // zero or one node
        if root == nil || root?.next == nil {
            return
        }
        
        // two or more nodes
        var prev = root
        var current = prev?.next
        while(current?.next != nil) {
            prev = current
            current = current?.next
        }
        prev?.next = nil
        current?.next = root
        root = current
        
    }
    
    
}


func constructDigitsFromString(str: String) {

    
    
}



print("ascii of a is ", "a".utf8)
print("unicode of a is ", UnicodeScalar(97))




func maxSubArray(nums: [Int]) {
    
    
    var curSum = 0
    var prevSum = 0
    var maxSum = nums[0]
    for num in nums {
//        if curSum < 0 {
//            curSum = 0
//        }
        
        //curSum += num
        curSum = max(num, curSum+num)
        maxSum = max(maxSum, curSum)
        
    }
    print("Max sub array ", maxSum)
}

let maxSumArrayNums = [-2,1,-3,4,-1, 2,1,-5,4]
let maxSumArrayNums1 =     [-2,-1,-3,-4,-1, -2,-1,-5,-4] //[-2, -1] //[2,3,4,1,4,6,9,0]

maxSubArray(nums: maxSumArrayNums)
maxSubArray(nums: maxSumArrayNums1)



//Even level - odd values, increasing values
//Odd level - even values, decresing values
func isEvenOddTree(node: TreeNode<Int>) -> Bool{
    var queue = [TreeNode<Int>]()
    queue[0] = node // add root node
    var level = 0 // first level = 0
    var isEvenLevel = true // level 0 is even, so initialize to true
    //loop thru until queue is empty
    var prevNode : TreeNode<Int>? = nil
    while(queue.count > 0) {
        var currentQueueSize = queue.count
        
        while(currentQueueSize > 0){
            var currentNode = queue.removeFirst()
            currentQueueSize -= 1
            if isEvenLevel {
                if (currentNode.value % 2 == 0){
                    return false
                }
                if let prevNode = prevNode, currentNode.value <= prevNode.value {
                    return false
                }
            }else{
                if (currentNode.value % 2 != 0){
                    return false
                }
                if let prevNode = prevNode, currentNode.value >= prevNode.value {
                    return false
                }
            }
            /// add child nodes to the queue
            if let leftNode = currentNode.left {
                queue.append(leftNode)
            }
            if let rightNode = currentNode.right {
                queue.append(rightNode)
            }
            prevNode = currentNode
        }
        // resetting level number and levelBoolean
        level += 1
        isEvenLevel = !isEvenLevel
    }
    return true
}

let boxes = [[4,1], [2,7], [5,10], [2,8]]
func maximumUnits(_ boxTypes: [[Int]], _ truckSize: Int) -> Int {
    
    let sortedBoxes = boxTypes.sorted { x, y in
        x[1] > y[1]
    }
    var currentTruckSize = 0
    var currentTotalUnits = 0
    print("sortedBoxes : ", sortedBoxes)
    for box in sortedBoxes{
        
        if currentTruckSize + box[0] <= truckSize {
            currentTruckSize += box[0]
            let currentBoxTotalUnits = box[0] * box[1]
            currentTotalUnits += currentBoxTotalUnits
        }
        else {
            var remainingLeft = truckSize - currentTruckSize
            currentTruckSize += remainingLeft
            let currentBoxTotalUnits = remainingLeft * box[1]
            currentTotalUnits += currentBoxTotalUnits
        }
            
        if currentTruckSize >= truckSize {
            //maxCapacityReached = true
            print("currentTotalUnits " , currentTotalUnits)
            break
        }
    }
    return 0
}

maximumUnits(boxes, 10)

let a = -12.0
let b = -2.3
print("ceil is", ceil(a-b))
print("abs is", abs(a-b))


func minValue( nums: [Int]) {
    print("nums ", nums)
    var minSum = Int.max
    var stepSum = 0
    
    for num in nums {
        stepSum += num
        minSum = min(minSum, stepSum)
    }
    if minSum < 0 {
        print("minValue ", abs(minSum) + 1)
    }
    else{
        print("minValue ", 1)
    }
    
}

let minVals1 = [1, -2, -3, 4, -7, 6, 5]

let minVals2 = [-3, 2, -3, 4, 2]

let minVals3 = [1,2,3,4,5]

print(minValue(nums: minVals1))
print(minValue(nums: minVals2))
print(minValue(nums: minVals3))


func countBits(number: Int) {
    var result = Array(repeating: 0, count: number)
    
    for num in 1..<number-1 {
//        if num%2 == 0 //even
//        {
//            result[num] = result[num/2]
//        }else{
//            result[num] = result[num/2] + 1
//        }
        
        result[num] = (num%2 == 0) ? result[num/2] : result[num/2] + 1
    }
    print("result is" , result)
}


countBits(number: 9)


func longestSubstringWithoutRepeatingCharacters(str: String) -> Int {
    print("string is ", str)
    var longestSubStr = ""
    var leftPtr = 0
    var rightPtr = 0
    var longestSubStrCount = 0
    //var subStrSet = Set<Character>()
    var subString = String()
    for char in str
    {
        
        if let firstIndex  = subString.firstIndex(of: char){
            longestSubStrCount = max(longestSubStrCount, subString.count)
            
            subString.removeSubrange(subString.startIndex...firstIndex)
            
            
        }
            
        subString.append(char)
    }
    print("Longest substring is ", longestSubStrCount)
    return longestSubStrCount
}

longestSubstringWithoutRepeatingCharacters(str:"pwwkew")


var mergeIntervalsArray = [[1,3],[2,6],[18,10],[15,18]]


mergeIntervalsArray = mergeIntervalsArray.sorted(by: { x, y in
     x[0] < y[0]
})

print("mergeIntervalsArray ", mergeIntervalsArray)



func permute(_ nums: [Int]) -> [[Int]] {
        print("nums ", nums)
        if nums.count == 1 { return [nums] }
        
        var res  = [[Int]]()
        var nums = nums
        
        for i in 0..<nums.count{
            let n = nums.removeFirst()
            print("n is ", n)
            var perms = permute(nums)
            print("perms ", perms)
            for i in 0..<perms.count{
                perms[i].append(n)
            }
            print("perms ", perms)
            res += perms
            print("res ", res)
            nums.append(n)
            
        }
        print("answer is ", res)
        return  res
    }


print(permute([1,2,3]))


func permute(nums:[Int]) -> [[Int]{
    if nums.count == 1 return [nums]
    var res, nums
    
        for i = 0 to nums.count
        let n = nums.removeFirst()
        perms = permute(nums)
        0 to perms.count{
        perms.append(n)
    }
    res += perms
    nums.append(n)
    
}
