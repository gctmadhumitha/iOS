//
//  PredictSpringTests.swift
//  PredictSpringTests
//
//  Created by Madhumitha Loganathan on 07/11/23.
//

import XCTest

@testable import PredictSpring
final class DownloadManagerTests: XCTestCase {
   
    private var downloadManager : DownloadManager!
    
    override func setUpWithError() throws {
        downloadManager = DownloadManager()
    }
    
    func testDownloadTaskEmptyURL() {
        let expectation = self.expectation(description: "testDownloadEmptyUrl")
        downloadManager.download(url: "", progressHandler: nil) { status in
            XCTAssertNotNil(status)
            XCTAssertEqual(status, DownloadStatus.error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testDownloadTaskInvalidURL() {
        let expectation = self.expectation(description: "testDownloadInvalidUrl")
         downloadManager.download(url: "xxxx", progressHandler: nil) { status in
            XCTAssertNotNil(status)
            XCTAssertEqual(status, DownloadStatus.error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testDownloadTaskValid(){
        let expectation = self.expectation(description: "testDownloadTask")
        downloadManager.download(url: Constants.mockfileUrl, progressHandler: nil, completionHandler: { status in
            if case let DownloadStatus.completed(url) = status  {
                XCTAssertNotNil(url)
                XCTAssertNotEqual(status, DownloadStatus.error)
                
                let fileManager = FileManager.default
                let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileUrl = directory.appendingPathComponent(url.lastPathComponent)
                let fileExists = fileManager.fileExists(atPath: fileUrl.path)
                XCTAssertTrue(fileExists)
            }
            else{
                XCTFail()
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 2.0)
    }   

    override func tearDownWithError() throws {
        downloadManager = nil
        UserDefaults.standard.setValue(false, forKey: Constants.isDownloadComplete)
    }
}
