//
//  DownloadManager.swift
//  PredictSpring
//
//  Created by Madhumitha Loganathan on 03/11/23.
//

import Foundation


class DownloadManager: NSObject {
    var progress: Float = 0 {
        didSet {
            self.progressHandler?(progress)
        }
    }
    
    var downloadComplete: Bool = false {
        didSet {
            UserDefaults.standard.set(downloadComplete, forKey: Constants.isDownloadComplete)
            if downloadComplete, let fileUrl = fileUrl {
                self.completionHandler?(.completed((fileUrl)))
            }else{
                self.completionHandler?(.error)
            }
        }
    }
   
    var fileUrl : URL?
    var progressHandler: ((Float) -> Void)?
    var completionHandler: ((DownloadStatus) -> Void)?
    let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    // MARK: - Properties
    private var configuration: URLSessionConfiguration
    private lazy var session: URLSession = {
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
        
        return session
    }()
    
    // MARK: - Initialization
    override init() {
        self.configuration = URLSessionConfiguration.background(withIdentifier: "backgroundTasks")
        super.init()
    }

    func download(url: String, progressHandler: ((Float) -> Void)?, completionHandler: ((DownloadStatus)->(Void))?){
        guard let url = URL(string: url) else {
            preconditionFailure("URL isn't true format!")
        }
        
        let fileManager = FileManager.default
        fileUrl = directory.appendingPathComponent(url.lastPathComponent)
        self.completionHandler = completionHandler
        if let fileUrl = fileUrl, fileManager.fileExists(atPath: fileUrl.path) {
            self.completionHandler?(.completed(fileUrl))
        }
        else{
            self.progressHandler = progressHandler
            self.completionHandler = completionHandler
            let task = session.downloadTask(with: url)
            task.resume()
        }
    }

}


// Delegate methods for URLSession, for downloading file
extension DownloadManager: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        self.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url else {
            print("error")
            return
        }
        let destinationURL = directory.appendingPathComponent(url.lastPathComponent)
        try? FileManager.default.removeItem(at: destinationURL)
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            DispatchQueue.main.async {
                self.downloadComplete = true
            }
        } catch {
            print(error)
        }
    }
}

enum DownloadStatus{
    case completed(URL)
    case error
}
