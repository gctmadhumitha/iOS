import Foundation

protocol Shareable {
    func socialNetworkingTitle() -> String
    func socialNetworkingUrl() -> URL?
}

struct User {
    let email: String
    let username: String
}

struct Post {
    let title: String
    let body: String
}

class SomeUserInput: Shareable {
    
    private let textContent: String
    
    init(textContent: String) {
        self.textContent = textContent
    }
    
    func socialNetworkingTitle() -> String {
        return textContent
    }
    
    func socialNetworkingUrl() -> URL? {
        let escapedContentString = textContent.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        return URL(string: "http://mywebsite.com/\(escapedContentString ?? "")")
    }
}

class UserShareableAdapter: Shareable {
    
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    func socialNetworkingTitle() -> String {
        return "Check out this user \(user.username)"
    }
    
    func socialNetworkingUrl() -> URL? {
        let escapedUsernameString = user.username.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        return URL(string: "http://mywebsite.com/users/\(escapedUsernameString ?? "")")
    }
}

class PostShareableAdapter: Shareable {
    
    private let post: Post
    
    init(post: Post) {
        self.post = post
    }
    
    func socialNetworkingTitle() -> String {
        return "Check out this post \(post.title)"
    }
    
    func socialNetworkingUrl() -> URL? {
        let escapedPostTitleString = post.title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        return URL(string: "http://mywebsite.com/posts/\(escapedPostTitleString ?? "")")
    }
}

class SocialSharingService {
    
    func shareShareable(shareable: Shareable) {
        print("sharing this on social networking")
        print("with the following title: \(shareable.socialNetworkingTitle())")
        print("and url: \(shareable.socialNetworkingUrl())")
    }
}


let user = User(email: "some@email.com", username: "some_username")
let post = Post(title: "some post title", body: "post content")

let someUserInout = SomeUserInput(textContent: "this is some user text")
let userShareableAdapter = UserShareableAdapter(user: user)
let postShareableAdapter = PostShareableAdapter(post: post)

let socialSharingService = SocialSharingService()

socialSharingService.shareShareable(shareable: someUserInout)
socialSharingService.shareShareable(shareable: userShareableAdapter)
socialSharingService.shareShareable(shareable: postShareableAdapter)
