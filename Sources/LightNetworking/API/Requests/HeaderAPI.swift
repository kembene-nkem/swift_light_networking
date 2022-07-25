//
//  File.swift


import Foundation

public extension LNET {

  struct HttpHeader: Hashable, CustomStringConvertible {
    public let name: String
    public let value: String
    public var description: String {
      "\(name): \(value)"
    }

    public static var defaultAcceptLanguage: HttpHeader = {
      var code: String? = nil
      if #available(macOS 13, iOS 16, *) {
        code = Locale.current.language.minimalIdentifier
      } else {
        code = Locale.current.languageCode
      }
      let lang = Locale.current.identifier.replacingOccurrences(of: "_", with: "-")
      return .acceptLanguage("\(lang),\(code ?? "en");q=0.5")
    }()

    public init(name: String, value: String) {
      self.name = name
      self.value = value
    }

    public func hash(into hasher: inout Hasher) {
      hasher.combine(name)
    }

    public static func accept(_ value: String)-> HttpHeader {
      HttpHeader(name: "Accept", value: value)
    }

    public static func acceptCharset(_ value: String)-> HttpHeader {
      HttpHeader(name: "Accept-Charset", value: value)
    }

    public static func acceptLanguage(_ value: String)-> HttpHeader {
      HttpHeader(name: "Accept-Language", value: value)
    }

    public static func acceptEncoding(_ value: String)-> HttpHeader {
      HttpHeader(name: "Accept-Encoding", value: value)
    }

    public static func authorization(username: String, password: String)-> HttpHeader {
      let auth = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() ?? ""
      return HttpHeader(name: "Authorization", value: "Basic \(auth)")
    }

    public static func authorization(bearerToken: String)-> HttpHeader {
      return HttpHeader(name: "Authorization", value: "Bearer \(bearerToken)")
    }

    public static func authorization(_ value: String)-> HttpHeader {
      return HttpHeader(name: "Authorization", value: value)
    }

    public static func contentDisposition(_ value: String)-> HttpHeader {
      return HttpHeader(name: "Content-Disposition", value: value)
    }

    public static func contentType(_ value: String)-> HttpHeader {      
      return HttpHeader(name: "Content-Type", value: value)
    }

    public static func userAgent(_ value: String)-> HttpHeader {
      return HttpHeader(name: "User-Agent", value: value)
    }

    public static func ==(lhs: HttpHeader, rhs: HttpHeader)-> Bool {
      lhs.hashValue == rhs.hashValue
    }
  }

  struct Headers: Sequence, Collection, CustomStringConvertible {

    private var headerList: [HttpHeader]

    public var startIndex: Int { headerList.startIndex }
    public var endIndex: Int   { headerList.endIndex }
    public var description: String {
      return "\(headerList)"
    }

    public init() {
      headerList = []
    }

    public init(headers: [HttpHeader]) {
      headerList = headers
    }

    public init(headers: [String: String]) {
      headerList = headers.enumerated().map{HttpHeader(name: $0.element.key, value: $0.element.value)}
    }

    @discardableResult
    mutating public func add(name: String, value: String)-> Self {
      return add(HttpHeader(name: name, value: value))
    }

    @discardableResult
    mutating public func add(_ header: HttpHeader)-> Self {
      headerList.append(header)
      return self
    }

    public subscript(index: Int) -> HttpHeader {
      headerList[index]
    }

    public func httpHeaderField()-> [String: String]? {
      guard headerList.isEmpty == false else { return nil }
      var header: [String: String] = [:]
      headerList.enumerated().forEach{ header[$0.element.name] = $0.element.value }
      return header
    }

    public func index(after i: Int) -> Int {
      precondition(i < endIndex, "Can't advance beyond endIndex")
      return i + 1
    }
  }
}
