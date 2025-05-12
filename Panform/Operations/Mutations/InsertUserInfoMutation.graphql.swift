// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Panform {
  class InsertUserInfoMutation: GraphQLMutation {
    static let operationName: String = "InsertUserInfo"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation InsertUserInfo($avatarUrl: String, $description: String!, $email: String!, $name: String!, $uid: String!) { insert_users_one( object: { email: $email uid: $uid name: $name description: $description avatarUrl: $avatarUrl } ) { __typename id } }"#
      ))

    public var avatarUrl: GraphQLNullable<String>
    public var description: String
    public var email: String
    public var name: String
    public var uid: String

    public init(
      avatarUrl: GraphQLNullable<String>,
      description: String,
      email: String,
      name: String,
      uid: String
    ) {
      self.avatarUrl = avatarUrl
      self.description = description
      self.email = email
      self.name = name
      self.uid = uid
    }

    public var __variables: Variables? { [
      "avatarUrl": avatarUrl,
      "description": description,
      "email": email,
      "name": name,
      "uid": uid
    ] }

    struct Data: Panform.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Panform.Objects.Mutation_root }
      static var __selections: [ApolloAPI.Selection] { [
        .field("insert_users_one", Insert_users_one?.self, arguments: ["object": [
          "email": .variable("email"),
          "uid": .variable("uid"),
          "name": .variable("name"),
          "description": .variable("description"),
          "avatarUrl": .variable("avatarUrl")
        ]]),
      ] }

      /// insert a single row into the table: "users"
      var insert_users_one: Insert_users_one? { __data["insert_users_one"] }

      /// Insert_users_one
      ///
      /// Parent Type: `Users`
      struct Insert_users_one: Panform.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Panform.Objects.Users }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", Panform.Uuid.self),
        ] }

        var id: Panform.Uuid { __data["id"] }
      }
    }
  }

}