import Foundation

class Post: NSObject, NSCoding {
  let remoteId: NSNumber
  let name: String
  
  init(remoteId: NSNumber, name: String) {
    self.remoteId = remoteId
    self.name = name
  }
  
  required convenience init?(coder decoder: NSCoder) {
    guard let remoteId = decoder.decodeObject(forKey: "remoteId") as? NSNumber,
      let name = decoder.decodeObject(forKey: "name") as? String
      else { return nil }
    
    self.init(remoteId: remoteId, name: name)
  }
  
  func encode(with coder: NSCoder) {
    coder.encode(remoteId, forKey: "remoteId")
    coder.encode(name, forKey: "name")
  }
}

class PostsStorage {
  
  private let userDefaults = UserDefaults.standard
  
  private let storageNameSpacePrefix = "my_posts_"
  
  func savePost(newPost: Post) {
    let newPostData = encodePost(post: newPost)
    let key = postKey(remoteId: newPost.remoteId)
    userDefaults.set(newPostData, forKey: key)
  }
  
  func getAllPosts() -> [Post] {
    return allPostKeys().map({ (key) -> NSData? in
      return userDefaults.object(forKey: key) as? NSData
    }).map({ (postData) -> Post? in
      return decodeToPost(data: postData)
    }).compactMap { $0 }
  }
  
  func findPostByRemoteId(remoteId: NSNumber) -> Post? {
    let key = postKey(remoteId: remoteId)
    let postData = userDefaults.object(forKey: key) as? NSData
    return decodeToPost(data: postData)
  }
  
  private func encodePost(post: Post) -> NSData {
    return NSKeyedArchiver.archivedData(withRootObject: post) as NSData
  }
  
  private func decodeToPost(data: NSData?) -> Post? {
    guard let data = data as Data? else { return nil }
    return NSKeyedUnarchiver.unarchiveObject(with: data) as? Post
  }
  
  private func postKey(remoteId: NSNumber) -> String {
    return "\(storageNameSpacePrefix)\(remoteId.stringValue)"
  }
  
  private func allPostKeys() -> [String] {
    return userDefaults.dictionaryRepresentation().keys.filter({ (key) -> Bool in
      return key.contains(storageNameSpacePrefix)
    })
  }
}

let postsStorage = PostsStorage()

let post1 = Post(remoteId: 1, name: "Post 1")
let post2 = Post(remoteId: 2, name: "Post 2")
let post3 = Post(remoteId: 3, name: "Post 3")
let post4 = Post(remoteId: 4, name: "Post 4")

postsStorage.savePost(newPost: post1)
postsStorage.savePost(newPost: post2)
postsStorage.savePost(newPost: post3)
postsStorage.savePost(newPost: post4)

print(postsStorage.getAllPosts())

if let post = postsStorage.findPostByRemoteId(remoteId: post2.remoteId) {
  print(post)
}
