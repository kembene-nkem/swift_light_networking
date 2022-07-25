public struct LNET {

  public struct RequestMethod: RawRepresentable, Equatable, Hashable {
    /// `CONNECT` method.
    public static let connect = RequestMethod(rawValue: "CONNECT")
    /// `DELETE` method.
    public static let delete = RequestMethod(rawValue: "DELETE")
    /// `GET` method.
    public static let get = RequestMethod(rawValue: "GET")
    /// `HEAD` method.
    public static let head = RequestMethod(rawValue: "HEAD")
    /// `OPTIONS` method.
    public static let options = RequestMethod(rawValue: "OPTIONS")
    /// `PATCH` method.
    public static let patch = RequestMethod(rawValue: "PATCH")
    /// `POST` method.
    public static let post = RequestMethod(rawValue: "POST")
    /// `PUT` method.
    public static let put = RequestMethod(rawValue: "PUT")
    /// `TRACE` method.
    public static let trace = RequestMethod(rawValue: "TRACE")

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
  }
  
}
