// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Panform {
  class DeleteUserMutation: GraphQLMutation {
    static let operationName: String = "deleteUser"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation deleteUser($uid: String!) { delete_users(where: { uid: { _eq: $uid } }) { __typename affected_rows } }"#
      ))

    public var uid: String

    public init(uid: String) {
      self.uid = uid
    }

    public var __variables: Variables? { ["uid": uid] }

    struct Data: Panform.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Panform.Objects.Mutation_root }
      static var __selections: [ApolloAPI.Selection] { [
        .field("delete_users", Delete_users?.self, arguments: ["where": ["uid": ["_eq": .variable("uid")]]]),
      ] }

      /// delete data from the table: "users"
      var delete_users: Delete_users? { __data["delete_users"] }

      /// Delete_users
      ///
      /// Parent Type: `Users_mutation_response`
      struct Delete_users: Panform.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Panform.Objects.Users_mutation_response }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("affected_rows", Int.self),
        ] }

        /// number of rows affected by the mutation
        var affected_rows: Int { __data["affected_rows"] }
      }
    }
  }

}