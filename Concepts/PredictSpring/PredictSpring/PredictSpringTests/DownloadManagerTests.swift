//
//  PredictSpringTests.swift
//  PredictSpringTests
//
//  Created by Madhumitha Loganathan on 07/11/23.
//

import XCTest

@testable import PredictSpring
final class DownloadManagerTests: XCTestCase {
   
    func test_DownloadTask_invalid_URL() {
        let expectation = self.expectation(description: "testDownload")
         DownloadManager().download(url: "", progressHandler: nil) { status in
            XCTAssertNotNil(status)
            XCTAssertEqual(status, DownloadStatus.error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    
    func test_DownloadTask_Valid(){
        let expectation = self.expectation(description: "testDownloadCompletion")
        DownloadManager().download(url: Constants.file_url, progressHandler: nil, completionHandler: { status in
            if case let DownloadStatus.completed(url) = status  {
                XCTAssertNotNil(url)
                XCTAssertNotEqual(status, DownloadStatus.error)
                
                let fileManager = FileManager.default
                let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileUrl = directory.appendingPathComponent(url.lastPathComponent)
                let fileExists = fileManager.fileExists(atPath: fileUrl.path)
                XCTAssertTrue(fileExists)
                XCTAssertTrue(UserDefaults.standard.bool(forKey: Constants.isDownloadComplete))
            }
            else{
                XCTFail()
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 2.0)
    }   

}
