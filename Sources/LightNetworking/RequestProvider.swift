//
//  File.swift


import Foundation

public class DefaultURLRequestProvider: URLRequestProvider {

  public let urlProvider: URLProvider
  public let apiAdapter: APIInformationAdapter
  public let interceptors: [Interceptor]
  public let urlSession: URLSession

  public init(provider: URLProvider,
              session: URLSession,
              interceptors: [Interceptor] = [],
              apiAdapter: @escaping APIInformationAdapter) {
    urlProvider = provider
    self.interceptors = interceptors
    self.apiAdapter = apiAdapter
    self.urlSession = session
  }

  public func request(_ api: APIInformation, mutator: RequestItemMutator? = nil) throws -> Subscription {
    let endpoint = try adaptAPIInformationToEndpoint(api: api, mutator: mutator)
    return performRequest(endpoint)
  }

  func adaptAPIInformationToEndpoint(api: APIInformation, mutator: RequestItemMutator? = nil) throws -> URLEndpoint {
    let provider = mutator?.provider ?? urlProvider
    guard let url = provider.provideURL(api: api) else {
      throw LightNetworking.Error.urlPrepareError
    }
    return try apiAdapter(api, url)
  }

  open func performRequest(_ endpoint: URLEndpoint) -> Subscription {
    let subscription = SubscriptionAdapter()

    var request: URLRequest?
    do {
      request = try endpoint.urlRequest()
    } catch {
      subscription.subscription = SubscriptionFailure(error: .requestMapping(error))
    }
    guard let request = request else { return subscription }

    let task = urlSession.dataTask(with: request) { data, response, error in

    }

    let innerSubscription = URLSubscriptionToken(task: task)
    subscription.subscription = innerSubscription
    task.resume()
    return subscription
  }
}
