//
//  PredictSpringTests.swift
//  PredictSpringTests
//
//  Created by Madhumitha Loganathan on 07/11/23.
//

import XCTest

@testable import PredictSpring
final class DownloadManagerTests: XCTestCase {
   
    func test_UnitTestDownloadTask_invalid_URL() {
        let expectation = self.expectation(description: "testDownload")
         DownloadManager().download(url: "", progressHandler: nil) { status in
            XCTAssertNotNil(status)
            XCTAssertEqual(status, DownloadStatus.error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    
    func test_UnitTestDownloadTask_Valid(){
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
    
 //   func test_UnitTestDownloadTask_Valid2(){
//        let expectation = self.expectation(description: "testDownload")
//        DownloadManager().download(url: Constants.file_url, progressHandler: { value in
//            print("value is", value)
//            XCTAssertNotNil(value)
//            XCTAssertGreaterThan(value, 0)
//            expectation.fulfill()
//            }, completionHandler: status in
//                                   if case let DownloadStatus.completed(url) = status  {
//        )
//        wait(for: [expectation], timeout: 2.0)
 //   }
    
    
//    //10 seconds delay added to check if download is complete by then
//    func test_UnitTestDownloadTask_No_URL() {
//        let downloadManager = DownloadTask()
//        let timeToWaitForDownload = 10.0
//        DispatchQueue.main.asyncAfter(deadline: .now() + timeToWaitForDownload) {
//            XCTAssertNotNil(downloadManager.csvUrl)
//        }
//    }
//
//    func test_UnitTestDownloadTask_downloadProgressUpdatedToOne() {
//        let downloadManager = DownloadTask()
//        downloadManager.startDownload()
//        let timeToWaitForDownload = 10.0
//        DispatchQueue.main.asyncAfter(deadline: .now() + timeToWaitForDownload) {
//            XCTAssertEqual(downloadManager.downloadProgress, 1)
//            XCTAssertTrue(downloadManager.downloadComplete)
//        }
//    }
//
//    func test_UnitTestDownloadTask_checkFileNotNone() {
//        let downloadManager = DownloadTask()
//        downloadManager.startDownload()
//        let timeToWaitForDownload = 10.0
//        DispatchQueue.main.asyncAfter(deadline: .now() + timeToWaitForDownload) {
//            let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let location = directory.appendingPathComponent(downloadManager.csvUrl!.path)
//            XCTAssertFalse(FileManager.default.fileExists(atPath: location.path))
//        }
//    }

}
