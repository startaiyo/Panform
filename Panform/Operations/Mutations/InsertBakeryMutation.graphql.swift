// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Panform {
  class InsertBakeryMutation: GraphQLMutation {
    static let operationName: String = "InsertBakery"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation InsertBakery($latitude: float8!, $longitude: float8!, $name: String!, $placeId: String!) { insert_bakeries_one( object: { latitude: $latitude, longitude: $longitude, name: $name, placeId: $placeId } ) { __typename id } }"#
      ))

    public var latitude: Float8
    public var longitude: Float8
    public var name: String
    public var placeId: String

    public init(
      latitude: Float8,
      longitude: Float8,
      name: String,
      placeId: String
    ) {
      self.latitude = latitude
      self.longitude = longitude
      self.name = name
      self.placeId = placeId
    }

    public var __variables: Variables? { [
      "latitude": latitude,
      "longitude": longitude,
      "name": name,
      "placeId": placeId
    ] }

    struct Data: Panform.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Panform.Objects.Mutation_root }
      static var __selections: [ApolloAPI.Selection] { [
        .field("insert_bakeries_one", Insert_bakeries_one?.self, arguments: ["object": [
          "latitude": .variable("latitude"),
          "longitude": .variable("longitude"),
          "name": .variable("name"),
          "placeId": .variable("placeId")
        ]]),
      ] }

      /// insert a single row into the table: "bakeries"
      var insert_bakeries_one: Insert_bakeries_one? { __data["insert_bakeries_one"] }

      /// Insert_bakeries_one
      ///
      /// Parent Type: `Bakeries`
      struct Insert_bakeries_one: Panform.SelectionSet {
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