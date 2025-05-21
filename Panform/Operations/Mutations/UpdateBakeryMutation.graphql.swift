// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Panform {
  class UpdateBakeryMutation: GraphQLMutation {
    static let operationName: String = "UpdateBakery"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation UpdateBakery($id: uuid!, $openingDays: [String!], $openAt: Int, $closeAt: Int) { update_bakeries_by_pk( pk_columns: { id: $id } _set: { openAt: $openAt, openingDays: $openingDays, closeAt: $closeAt } ) { __typename id } }"#
      ))

    public var id: Uuid
    public var openingDays: GraphQLNullable<[String]>
    public var openAt: GraphQLNullable<Int>
    public var closeAt: GraphQLNullable<Int>

    public init(
      id: Uuid,
      openingDays: GraphQLNullable<[String]>,
      openAt: GraphQLNullable<Int>,
      closeAt: GraphQLNullable<Int>
    ) {
      self.id = id
      self.openingDays = openingDays
      self.openAt = openAt
      self.closeAt = closeAt
    }

    public var __variables: Variables? { [
      "id": id,
      "openingDays": openingDays,
      "openAt": openAt,
      "closeAt": closeAt
    ] }

    struct Data: Panform.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Panform.Objects.Mutation_root }
      static var __selections: [ApolloAPI.Selection] { [
        .field("update_bakeries_by_pk", Update_bakeries_by_pk?.self, arguments: [
          "pk_columns": ["id": .variable("id")],
          "_set": [
            "openAt": .variable("openAt"),
            "openingDays": .variable("openingDays"),
            "closeAt": .variable("closeAt")
          ]
        ]),
      ] }

      /// update single row of the table: "bakeries"
      var update_bakeries_by_pk: Update_bakeries_by_pk? { __data["update_bakeries_by_pk"] }

      /// Update_bakeries_by_pk
      ///
      /// Parent Type: `Bakeries`
      struct Update_bakeries_by_pk: Panform.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Panform.Objects.Bakeries }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", Panform.Uuid.self),
        ] }

        var id: Panform.Uuid { __data["id"] }
      }
    }
  }

}