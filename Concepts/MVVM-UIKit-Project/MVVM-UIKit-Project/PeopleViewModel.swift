//
//  PeopleViewModel.swift
//  MVVM-UIKit-Project
//
//  Created by Madhumitha Loganathan on 26/09/23.
//

import Foundation

protocol PeopleViewModelDelegate : AnyObject {
    func didFinish()
    func didFail(error: Error)
}

class PeopleViewModel {
    
    private(set) var people = [PersonResponse]()
    weak var delegate: PeopleViewModelDelegate?
    
    func getUsersResult() async -> Result<UsersResponse, AppError> {
        do {
            guard let url  = URL(string: "https://reqres.in/api/users") else {
                return Result.failure(.DecodingError)
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let users = try jsonDecoder.decode(UsersResponse.self, from: data)
            return Result.success(users)
        } catch {
            print(error)
            return Result.failure(.OtherError("Error Caught while getting users \(error)"))
        }
    }
    
    @MainActor
    func getUsers() {
        Task { [weak self] in
            do {
                let url  = URL(string: "https://reqres.in/api/users")!
                let (data, _) = try await URLSession.shared.data(from: url)
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let users = try jsonDecoder.decode(UsersResponse.self, from: data)
                self?.people = users.data
                self?.delegate?.didFinish()
            } catch {
                self?.delegate?.didFail(error: error)
            }
        }
    }

}

enum AppError : Error {
    case DecodingError
    case URLNotFound
    case OtherError(String)
}
