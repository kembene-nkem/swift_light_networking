//
//  File.swift

import Foundation

/// Possible errors that could occur while performing requests and response processing
public enum Error: Swift.Error {
  /// Thrown when we are unable to generate a URL that will be used for the request
  case urlPrepareError
  /// indicates there was an error while trying to decode the response
  case decodingError(Response, Swift.Error?)

  /// Indicates there was an error while trying to encode the request
  case requestEncodingError(Swift.Error?)

  /// States that a response failed with an invalid status code
  case statusCode(Response)

  /// Indicates an error which LightNetworking does not understand occurred due to an underlying `Error`.
  case general(Swift.Error, Response?)

  /// Indicates that a `URLEndpoint`while being mapped to a `URLRequest`, due to an optional original error.
  case requestMapping(Swift.Error?)

}
