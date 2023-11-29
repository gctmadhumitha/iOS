import Foundation
import CoreData

struct Post {
  let remoteId: NSNumber
  let name: String
}

class PostManagedObject: NSManagedObject {
  @NSManaged var remoteId: NSNumber
  @NSManaged var name: String
  
  static func postManagedObject(remoteId: NSNumber, name: String, context: NSManagedObjectContext) -> PostManagedObject? {
    guard let entity = entityDescription(context: context) else { return nil }
    
    let postManagedObject = PostManagedObject(entity: entity, insertInto: context)
    postManagedObject.remoteId = remoteId
    postManagedObject.name = name
    return postManagedObject
  }
  
  private static func entityDescription(context: NSManagedObjectContext) -> NSEntityDescription? {
    let entityName = NSStringFromClass(self)
    return NSEntityDescription.entity(forEntityName: entityName, in: context)
  }
}

class PostsStorage {
  
  private let persistentStoreCoordinator: NSPersistentStoreCoordinator
  private let managedObjectContext: NSManagedObjectContext
  
  init() {
    let postEntityDescriptior = NSEntityDescription()
    postEntityDescriptior.name = NSStringFromClass(PostManagedObject.self)
    postEntityDescriptior.managedObjectClassName = NSStringFromClass(PostManagedObject.self)
    
    let remoteIdAttributeDescriptor = NSAttributeDescription()
    remoteIdAttributeDescriptor.name = "remoteId"
    remoteIdAttributeDescriptor.attributeType = .integer64AttributeType
    remoteIdAttributeDescriptor.isOptional = false
    
    let nameAttribute = NSAttributeDescription()
    nameAttribute.name = "name"
    nameAttribute.attributeType = .stringAttributeType
    nameAttribute.isOptional = false
    
    let remoteIdIndexElementDescription = NSFetchIndexElementDescription(property: remoteIdAttributeDescriptor, collationType: .binary)
    let remoteIdIndexDescription = NSFetchIndexDescription(name: "remoteIdIndex", elements: [remoteIdIndexElementDescription])
    
    postEntityDescriptior.properties = [remoteIdAttributeDescriptor, nameAttribute]
    
    let managedObjectModel = NSManagedObjectModel()
    managedObjectModel.entities = [postEntityDescriptior]
    
    postEntityDescriptior.indexes = [remoteIdIndexDescription]
    
    persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
    do {
      try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
    }
    catch {
      print("error creating persistentStoreCoordinator: \(error)")
    }
    
    managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
  }
  
  func savePost(newPost: Post) {
    encodePost(post: newPost)
    saveDataToDatabase()
  }
  
  func getAllPosts() -> [Post] {
    
    let fetchRequest = baseFetchRequest()
    
    if let postManagedObjects = executeFetchRequest(fetchRequest: fetchRequest) {
      return postManagedObjects.map({ (postManagedObject) -> Post in
        return decodeToPost(postManagedObject: postManagedObject)
      })
    } else {
      return []
    }
  }
  
  func findPostByRemoteId(remoteId: NSNumber) -> Post? {
    
    let fetchRequest = baseFetchRequest()
    
    fetchRequest.predicate = NSPredicate(format: "remoteId == %@", remoteId)
    
    if let postManagedObject = executeFetchRequest(fetchRequest: fetchRequest)?.first {
      return decodeToPost(postManagedObject: postManagedObject)
    } else {
      return nil
    }
  }
  
  private func encodePost(post: Post) {
    PostManagedObject.postManagedObject(remoteId: post.remoteId, name: post.name, context: managedObjectContext)
  }
  
  private func decodeToPost(postManagedObject: PostManagedObject) -> Post {
    return Post(remoteId: postManagedObject.remoteId, name: postManagedObject.name)
  }
  
  private func saveDataToDatabase() -> Bool {
    if managedObjectContext.hasChanges {
      do {
        try managedObjectContext.save()
        return true
      } catch {
        return false
      }
    } else {
      return false
    }
  }
  
  private func baseFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: NSStringFromClass(PostManagedObject.self))
    
    let sort = NSSortDescriptor(key: "remoteId", ascending: true)
    fetchRequest.sortDescriptors = [sort]
    
    return fetchRequest
  }
  
  private func executeFetchRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>) -> [PostManagedObject]? {
    return (try? managedObjectContext.fetch(fetchRequest)) as? [PostManagedObject]
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
