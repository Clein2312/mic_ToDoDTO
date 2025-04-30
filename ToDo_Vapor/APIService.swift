//
//  APIService.swift
//  ToDo_Vapor
//
//  Created by Patrick on 30.04.25.
//

import Foundation

//Errer response object
struct ErrorResponse: Decodable {
    let message: String?
}

//API errors
enum APIError: Error {
    case invalidResponse(statusCode: Int, message: String?)
    case decodingError(Error)
    case networkError(URLError)
    case unknown(Error)
}

//Empty response for DELETE operations
struct EmptyResponse: Decodable {}


class APIService: ObservableObject {
    static let shared = APIService()
    internal let baseURL = URL(string: "http://127.0.0.1:8080")!
        
    private init() { }
    
    //Request creation including bearer token
    internal func authorizedRequest(url: URL, method: String, payload: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = payload
        return request
    }
    
    //Generic response handler
    internal func handleResponse<T: Decodable>(_ type: T.Type,
                                              data: Data,
                                              response: URLResponse,
                                              validStatusCodes: [Int] = Array(200...299)) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse(statusCode: -1, message: "No HTTP response")
        }
        
        guard validStatusCodes.contains(httpResponse.statusCode) else {
            let errorMessage: String?
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                errorMessage = errorResponse.message
            } else {
                errorMessage = nil
            }
            throw APIError.invalidResponse(statusCode: httpResponse.statusCode, message: errorMessage)
        }
        do
            {
            let string = String(bytes: data, encoding: .utf8)
            print(string ?? "nil")
            let hex = data.map{ String($0, radix: 16) }.joined(separator: " ")
            print(hex)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("\(json)")
            }
        catch
        {
        print("\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    func createToDoItem(data: ToDoItemCreateDTO) async throws -> ToDoItemResponseDTO {
           let encoder = JSONEncoder()
           encoder.dateEncodingStrategy = .iso8601
           let payload = try encoder.encode(data)
           let request = authorizedRequest(url: baseURL, method: "POST", payload: payload)
           let (responseData, response) = try await URLSession.shared.data(for: request)
           return try handleResponse(ToDoItemResponseDTO.self, data: responseData, response: response)
       }
       
       func updateToDoItem(id: UUID, data: ToDoItemUpdateDTO) async throws -> ToDoItemResponseDTO {
           let encoder = JSONEncoder()
           encoder.dateEncodingStrategy = .iso8601
           let payload = try encoder.encode(data)
           let request = authorizedRequest(url: baseURL, method: "PATCH", payload: payload)
           let (responseData, response) = try await URLSession.shared.data(for: request)
           return try handleResponse(ToDoItemResponseDTO.self, data: responseData, response: response)
       }
       
       func fetchToDoItem(id: UUID) async throws -> ToDoItemResponseDTO {
           let request = authorizedRequest(url: baseURL, method: "GET")
           let (responseData, response) = try await URLSession.shared.data(for: request)
           return try handleResponse(ToDoItemResponseDTO.self, data: responseData, response: response)
       }
       
       func fetchToDoItems() async throws -> [ToDoItemResponseDTO] {
          
           let request = authorizedRequest(url: baseURL, method: "GET")
           let (responseData, response) = try await URLSession.shared.data(for: request)
           return try handleResponse([ToDoItemResponseDTO].self, data: responseData, response: response)
       }
       
       func deleteToDoItem(id: UUID) async throws {
           let request = authorizedRequest(url: baseURL, method: "DELETE")
           let (responseData, response) = try await URLSession.shared.data(for: request)
           _ = try handleResponse(EmptyResponse.self, data: responseData, response: response)
       }

}
