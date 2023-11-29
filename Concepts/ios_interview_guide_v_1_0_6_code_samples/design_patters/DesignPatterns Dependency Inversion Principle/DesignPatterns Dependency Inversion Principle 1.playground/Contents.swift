class MyAPIClient {
    
    func httpGet(url: String, success: @escaping () -> Void, failure: @escaping () -> Void) {
        // let's assume we do some http networking stuff here
        
        // and let's pretend it succeeds
        
        success()
    }
}

class PostsService {
    
    lazy var apiClient: MyAPIClient = { [unowned self] in
        return MyAPIClient()
    }()
    
    func fetchPostsFromServer(success: @escaping () -> Void, failure: @escaping () -> Void) {
        // more business logic to prepare url and params here
        
        let postsUrl = "some_endpoint_url"
        
        apiClient.httpGet(url: postsUrl, success: {
            success()
        }, failure: {
            failure()
        })
    }
}


let postsService = PostsService()
postsService.fetchPostsFromServer(success: {
    print("change some UI upon successful fetch of posts here")
}, failure: {
    print("show some alert with an error")
})
