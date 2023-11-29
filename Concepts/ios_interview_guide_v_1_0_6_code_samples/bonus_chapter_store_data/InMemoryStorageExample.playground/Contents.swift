import Foundation

struct Post {
  let remoteId: Int
  let name: String
}

class PostsStorage {
  
  private var posts = [Int: Post]()
  
  func savePost(newPost: Post) {
    posts[newPost.remoteId] = newPost
  }
  
  func getAllPosts() -> [Post] {
    return posts.keys.map { posts[$0] }.flatMap { $0 }
  }
  
  func findPost(remoteId: Int) -> Post? {
    return posts[remoteId]
  }
}

let postsStorage = PostsStorage()

let post1 = Post(remoteId: 1, name: "Post 1")
let post2 = Post(remoteId: 2, name: "Post 2")
let post3 = Post(remoteId: 3, name: "Post 3")
let post4 = Post(remoteId: 4, name: "Post 4")

print(postsStorage.getAllPosts())

postsStorage.savePost(newPost: post1)
postsStorage.savePost(newPost: post2)
postsStorage.savePost(newPost: post3)
postsStorage.savePost(newPost: post4)


print(postsStorage.getAllPosts())

if let post = postsStorage.findPost(remoteId: post2.remoteId) {
  print(post)
}
