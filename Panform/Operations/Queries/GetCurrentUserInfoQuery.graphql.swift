// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Panform {
  class GetCurrentUserInfoQuery: GraphQLQuery {
    static let operationName: String = "GetCurrentUserInfo"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetCurrentUserInfo($uid: String!) { users(where: { uid: { _eq: $uid } }) { __typename avatarUrl description email id name uid } }"#
      ))

    public var uid: String

    public init(uid: String) {
      self.uid = uid
    }

    public var __variables: Variables? { ["uid": uid] }

    struct Data: Panform.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Panform.Objects.Query_root }
      static var __selections: [ApolloAPI.Selection] { [
        .field("users", [User].self, arguments: ["where": ["uid": ["_eq": .variable("uid")]]]),
      ] }

      /// fetch data from the table: "users"
      var users: [User] { __data["users"] }

      /// User
      ///
      /// Parent Type: `Users`
      struct User: Panform.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Panform.Objects.Users }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("avatarUrl", String?.self),
          .field("description", String.self),
          .field("email", String.self),
          .field("id", Panform.Uuid.self),
          .field("name", String.self),
          .field("uid", String.self),
        ] }

        var avatarUrl: String? { __data["avatarUrl"] }
        var description: String { __data["description"] }
        var email: String { __data["email"] }
        var id: Panform.Uuid { __data["id"] }
        var name: String { __data["name"] }
        var uid: String { __data["uid"] }
      }
    }
  }

}