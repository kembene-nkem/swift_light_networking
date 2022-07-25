//
//  File.swift


import Foundation

public protocol URLProvider {
  func provideURL(api: APIInformation)-> URL?
}

public struct RequestItemMutator {
  public private(set) var provider: URLProvider?
  public private(set)  var interceptors: [Interceptor]?

  private init(){}

  public mutating func useProvider(provider: URLProvider? = nil)-> Self {
    self.provider = provider
    return self
  }

  public mutating func intercept(with interceptors: [Interceptor]? = nil)-> Self {
    self.interceptors = interceptors
    return self
  }

  public static func instance() -> RequestItemMutator { RequestItemMutator() }
}

public protocol URLRequestProvider {
  func request(_ api: APIInformation, mutator: RequestItemMutator?)throws -> Subscription
}

public protocol Subscription {
  var isCancelled: Bool { get }
  mutating func cancel()
  mutating func then<ResultType>(completion: @escaping ResponseCallback<ResultType>)
}

class SubscriptionAdapter: Subscription {
  internal var subscription: Subscription = EmptyCancellable()

  var isCancelled: Bool { subscription.isCancelled }

  internal func cancel() {
    subscription.cancel()
  }

  func then<ResultType>(completion: @escaping ResponseCallback<ResultType>) { subscription.then(completion: completion) }
}

struct SubscriptionFailure: Subscription {
  var isCancelled: Bool = false

  let error: LightNetworking.Error
  init(error: LightNetworking.Error) {
    self.error = error
  }
  mutating func cancel() {
    isCancelled = true
  }

  mutating func then<ResultType>(completion: @escaping ResponseCallback<ResultType>) {
    guard isCancelled == false else { return }
    isCancelled = true
    completion(.failure(error))
  }
}

internal class EmptyCancellable: Subscription {

  var isCancelled = false
  func cancel() {
      isCancelled = true
  }
  func then<ResultType>(completion: @escaping ResponseCallback<ResultType>) { }
}

public class URLSubscriptionToken: Subscription {
  let task: URLSessionDataTask

  public var isCancelled = false

  init(task: URLSessionDataTask) {
    self.task = task
  }

  public func cancel() {
    if isCancelled == false {
      return
    }
    isCancelled = true
    task.cancel()
  }

  public func then<ResultType>(completion: @escaping ResponseCallback<ResultType>) { }

  func onResultAvailable<ResultType>(response: Result<ResultType, LightNetworking.Error>) {
    /// todo
  }
}
