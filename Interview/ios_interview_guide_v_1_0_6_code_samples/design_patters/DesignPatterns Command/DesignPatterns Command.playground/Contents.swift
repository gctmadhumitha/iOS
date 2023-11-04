import Foundation

protocol Command {
    var result: String? { get }
    func execute()
}

class HTTPGetRequestCommand: Command {
    
    private let url: URL
    
    var result: String?
    
    init(url: URL) {
        self.url = url
    }
    
    func execute() {
        print("fetching data from \(url)")
        print(".....")
        print("done")
        result = "this is some json that we got from the backend"
    }
}

class StorageSaveCommand: Command {
    
    var result: String?
    
    private let dataToSaveToDisk: String
    
    init(dataToSave: String) {
        self.dataToSaveToDisk = dataToSave
    }
    
    func execute() {
        print("saving \(dataToSaveToDisk) to disk")
        print("......")
        result = "ok"
        print("done")
    }
}

let productUrl = URL(string: "http://my-awesome-app.com/api/v1/products/12345")!

let getRequestCommand = HTTPGetRequestCommand(url: productUrl)
getRequestCommand.execute()
let jsonResult = getRequestCommand.result!

let saveToStorageCommand = StorageSaveCommand(dataToSave: jsonResult)
saveToStorageCommand.execute()
