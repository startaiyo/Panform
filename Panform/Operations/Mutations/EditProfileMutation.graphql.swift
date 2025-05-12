// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Panform {
  class EditProfileMutation: GraphQLMutation {
    static let operationName: String = "EditProfile"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation EditProfile($name: String!, $id: uuid!, $description: String!, $avatarUrl: String!) { update_users_by_pk( pk_columns: { id: $id } _set: { avatarUrl: $avatarUrl, description: $description, name: $name } ) { __typename id } }"#
      ))

    public var name: String
    public var id: Uuid
    public var description: String
    public var avatarUrl: String

    public init(
      name: String,
      id: Uuid,
      description: String,
      avatarUrl: String
    ) {
      self.name = name
      self.id = id
      self.description = description
      self.avatarUrl = avatarUrl
    }

    public var __variables: Variables? { [
      "name": name,
      "id": id,
      "description": description,
      "avatarUrl": avatarUrl
    ] }

    struct Data: Panform.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Panform.Objects.Mutation_root }
      static var __selections: [ApolloAPI.Selection] { [
        .field("update_users_by_pk", Update_users_by_pk?.self, arguments: [
          "pk_columns": ["id": .variable("id")],
          "_set": [
            "avatarUrl": .variable("avatarUrl"),
            "description": .variable("description"),
            "name": .variable("name")
          ]
        ]),
      ] }

      /// update single row of the table: "users"
      var update_users_by_pk: Update_users_by_pk? { __data["update_users_by_pk"] }

      /// Update_users_by_pk
      ///
      /// Parent Type: `Users`
      struct Update_users_by_pk: Panform.SelectionSet {
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