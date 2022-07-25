//
//  File.swift

import Foundation

public typealias RequestParameters = [String : Any]
public typealias EncodedURLRequest = URLRequest

fileprivate var registeredIdentityDatabase: [String: LNET.Identity] = [:]

public protocol APIIdentity {
  var value: String { get }
  init?(valueOf: String)
}

public extension LNET {
  struct Identity: APIIdentity, RawRepresentable, Hashable {
    public var rawValue: String
    public var value: String { rawValue }

    public init(rawValue identity: String) {
        assert(registeredIdentityDatabase[identity] == nil, "An API identity with name \(identity) is already registered")
        rawValue = identity
      registeredIdentityDatabase[identity] = self
    }

    public init?(valueOf: String) {
      guard let value = registeredIdentityDatabase[valueOf] else { return nil }
        if registeredIdentityDatabase[valueOf] == nil {
            return nil
        }
        self = value
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
  }
}

public protocol APIInformationTask {
  func encodeRequest(urlRequest: URLRequest) throws -> EncodedURLRequest
}

public protocol APIInformation {
  /// The base url for this particular API.
  /// - Note: If this function returns a URL instance, then that instance is used to construct the absolute URL
  ///   otherwise, the `NetworkClient` uses it's own base URL to construct the absolute endpoint
  func baseURL()-> URL?
  /// The path to be appended to the base URL
  func path()-> String
  /// The HTTP Method to use for this request
  func method()-> LNET.RequestMethod
  func headers()-> LNET.Headers?
  func identity()-> APIIdentity?
  func prepareTask()-> APIInformationTask
}

public extension APIInformation {
  func method()-> LNET.RequestMethod { .get }
  func headers()-> LNET.Headers? { nil }
  func identity()-> APIIdentity? { nil }
  func baseURL()-> URL? { nil }
}

public protocol URLEndpoint {
  var apiInformation: APIInformation { get }
  var apiInformationTask: APIInformationTask { get }
  var headers: LNET.Headers { get }
  var url: URL { get }

  init(baseURL: URL)
  func add(newHTTPHeaderFields: [String: String]) -> Self
  func replace(task: APIInformationTask) -> Self
  func replace(api: APIInformation) -> Self
  func urlRequest() throws -> URLRequest
}

public extension URLEndpoint {
  func urlRequest() throws -> URLRequest {
    var request = URLRequest(url: url)

    request.httpMethod = apiInformation.method().rawValue
    request.allHTTPHeaderFields = apiInformation.headers()?.httpHeaderField()

    do {
      request = try apiInformationTask.encodeRequest(urlRequest: request)
    }catch {
      throw LightNetworking.Error.requestEncodingError(error)
    }

    return request
  }
}

public protocol RequestParameterEncoding {
  func encode(_ endpoint: URLEndpoint, with parameters: RequestParameters?) throws -> URLRequest
}
