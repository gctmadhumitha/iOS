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
            self.completionHandler?(downloadComplete)
        }
    }
   
    var progressHandler: ((Float) -> Void)?
    var completionHandler: ((Bool) -> Void)?
    
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

    func download(url: String, progress: ((Float) -> Void)?, completion: ((Bool)->(Void))?){
        /// bind progress closure to View
        self.progressHandler = progress
        self.completionHandler = completion
        /// handle url
        guard let url = URL(string: url) else {
            preconditionFailure("URL isn't true format!")
        }
        let task = session.downloadTask(with: url)
        task.resume()
    }

}

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
        self.downloadComplete = true
    }
}
