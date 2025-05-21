// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Panform {
  class GetBakeryByPlaceIdQuery: GraphQLQuery {
    static let operationName: String = "GetBakeryByPlaceId"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetBakeryByPlaceId($placeId: String!) { bakeries(where: { placeId: { _eq: $placeId } }) { __typename name placeId id openingDays openAt name longitude latitude closeAt } }"#
      ))

    public var placeId: String

    public init(placeId: String) {
      self.placeId = placeId
    }

    public var __variables: Variables? { ["placeId": placeId] }

    struct Data: Panform.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Panform.Objects.Query_root }
      static var __selections: [ApolloAPI.Selection] { [
        .field("bakeries", [Bakery].self, arguments: ["where": ["placeId": ["_eq": .variable("placeId")]]]),
      ] }

      /// fetch data from the table: "bakeries"
      var bakeries: [Bakery] { __data["bakeries"] }

      /// Bakery
      ///
      /// Parent Type: `Bakeries`
      struct Bakery: Panform.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Panform.Objects.Bakeries }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("name", String.self),
          .field("placeId", String.self),
          .field("id", Panform.Uuid.self),
          .field("openingDays", [String]?.self),
          .field("openAt", Int?.self),
          .field("longitude", Panform.Float8.self),
          .field("latitude", Panform.Float8.self),
          .field("closeAt", Int?.self),
        ] }

        var name: String { __data["name"] }
        var placeId: String { __data["placeId"] }
        var id: Panform.Uuid { __data["id"] }
        var openingDays: [String]? { __data["openingDays"] }
        var openAt: Int? { __data["openAt"] }
        var longitude: Panform.Float8 { __data["longitude"] }
        var latitude: Panform.Float8 { __data["latitude"] }
        var closeAt: Int? { __data["closeAt"] }
      }
    }
  }

}