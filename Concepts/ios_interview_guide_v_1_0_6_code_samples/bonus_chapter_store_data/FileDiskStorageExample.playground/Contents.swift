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
  
  private let fileManager = FileManager.default
  
  private let storageNameSpacePrefix = "my_posts_"
  
  func savePost(newPost: Post) {
    let newPostData = encodePost(post: newPost)
    let key = postKey(remoteId: newPost.remoteId)
    let directory = documentsDirectory()
    saveDataToDisk(fileName: key, directoryPath: directory, data: newPostData)
  }
  
  func getAllPosts() -> [Post] {
    return allPostKeys().map({ (fileName) -> Data? in
      let path = fullPostPath(postKey: fileName)
      return fileManager.contents(atPath: path)
    }).map({ (postData) -> Post? in
      return decodeToPost(data: postData)
    }).compactMap { $0 }
  }
  
  func findPostByRemoteId(remoteId: NSNumber) -> Post? {
    let postPath = fullPostPath(postKey: postKey(remoteId: remoteId))
    let postData = self.fileManager.contents(atPath: postPath)
    return decodeToPost(data: postData)
  }
  
  private func postKey(remoteId: NSNumber) -> String {
    return "\(storageNameSpacePrefix)\(remoteId.stringValue)"
  }
  
  private func allPostKeys() -> [String] {
    do {
      let directory = documentsDirectory()
      return try fileManager.contentsOfDirectory(atPath: directory).filter({ (path) -> Bool in
        return path.contains(storageNameSpacePrefix)
      })
    } catch {
      return []
    }
  }
  
  private func encodePost(post: Post) -> Data {
    return NSKeyedArchiver.archivedData(withRootObject: post)
  }
  
  private func decodeToPost(data: Data?) -> Post? {
    guard let data = data else { return nil }
    return NSKeyedUnarchiver.unarchiveObject(with: data) as? Post
  }
  
  private func documentsDirectory() -> String {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                               .userDomainMask,
                                               true).first! + "/posts_storage"
  }
  
  private func saveDataToDisk(fileName: String, directoryPath: String, data: Data) -> Bool {
    
    let filePath = "\(directoryPath)/\(fileName)"
    
    do {
      try fileManager.createDirectory(atPath: directoryPath,
                                      withIntermediateDirectories: true,
                                      attributes: nil)
      let success = fileManager.createFile(atPath: filePath,
                                           contents: data,
                                           attributes: nil)
      return success
      
    } catch {
      return false
    }
  }
  
  private func fullPostPath(postKey: String) -> String {
    return documentsDirectory() + "/" + postKey
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
