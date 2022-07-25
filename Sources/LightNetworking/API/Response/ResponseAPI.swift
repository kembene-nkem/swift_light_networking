//
//  File.swift


import Foundation

public typealias ResultCallback = (_ result: Result<Response, LightNetworking.Error>) -> Void
public typealias ResponseCallback<T> = (_ result: Result<T, LightNetworking.Error>) -> Void

public protocol Interceptor {
  func prepare(request: URLRequest, api: APIInformation) -> URLRequest
  func didReceive(result: Swift.Result<Response, LightNetworking.Error>, api: APIInformation)-> Swift.Result<Response, LightNetworking.Error>
}

public class Response {
  public let status: Int
  public let api: APIInformation
  public let request: URLRequest?
  public let urlResponse: HTTPURLResponse?
  public let data: Data?


  public init(status: Int, api: APIInformation, request: URLRequest? = nil, urlResponse: HTTPURLResponse? = nil, data: Data? = nil) {
    self.status = status
    self.api = api
    self.request = request
    self.urlResponse = urlResponse
    self.data = data
  }

  public static func == (lhs: Response, rhs: Response) -> Bool {
    return lhs.urlResponse == rhs.urlResponse
      && lhs.status == rhs.status
  }
}

public struct DecodedResponse<T> {

  var result: T?
  var response: Response

  public init(result: T? = nil, response: Response) {
    self.result = result
    self.response = response
  }
}
