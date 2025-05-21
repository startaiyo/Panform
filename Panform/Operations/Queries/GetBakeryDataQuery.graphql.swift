// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Panform {
  class GetBakeryDataQuery: GraphQLQuery {
    static let operationName: String = "GetBakeryData"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetBakeryData($bakeryID: uuid!) { bakeries(where: { id: { _eq: $bakeryID } }) { __typename name placeId id openingDays openAt name longitude latitude closeAt breads { __typename id name price breadReviews { __typename comment rate id userId } breadPhotos { __typename imageUrl id userId } } } }"#
      ))

    public var bakeryID: Uuid

    public init(bakeryID: Uuid) {
      self.bakeryID = bakeryID
    }

    public var __variables: Variables? { ["bakeryID": bakeryID] }

    struct Data: Panform.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Panform.Objects.Query_root }
      static var __selections: [ApolloAPI.Selection] { [
        .field("bakeries", [Bakery].self, arguments: ["where": ["id": ["_eq": .variable("bakeryID")]]]),
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
          .field("breads", [Bread].self),
        ] }

        var name: String { __data["name"] }
        var placeId: String { __data["placeId"] }
        var id: Panform.Uuid { __data["id"] }
        var openingDays: [String]? { __data["openingDays"] }
        var openAt: Int? { __data["openAt"] }
        var longitude: Panform.Float8 { __data["longitude"] }
        var latitude: Panform.Float8 { __data["latitude"] }
        var closeAt: Int? { __data["closeAt"] }
        /// fetch data from the table: "breads"
        var breads: [Bread] { __data["breads"] }

        /// Bakery.Bread
        ///
        /// Parent Type: `Breads`
        struct Bread: Panform.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { Panform.Objects.Breads }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", Panform.Uuid.self),
            .field("name", String.self),
            .field("price", Int.self),
            .field("breadReviews", [BreadReview].self),
            .field("breadPhotos", [BreadPhoto].self),
          ] }

          var id: Panform.Uuid { __data["id"] }
          var name: String { __data["name"] }
          var price: Int { __data["price"] }
          /// An array relationship
          var breadReviews: [BreadReview] { __data["breadReviews"] }
          /// fetch data from the table: "breadPhotos"
          var breadPhotos: [BreadPhoto] { __data["breadPhotos"] }

          /// Bakery.Bread.BreadReview
          ///
          /// Parent Type: `BreadReviews`
          struct BreadReview: Panform.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: any ApolloAPI.ParentType { Panform.Objects.BreadReviews }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("comment", String.self),
              .field("rate", Panform.Float8.self),
              .field("id", Panform.Uuid.self),
              .field("userId", Panform.Uuid.self),
            ] }

            var comment: String { __data["comment"] }
            var rate: Panform.Float8 { __data["rate"] }
            var id: Panform.Uuid { __data["id"] }
            var userId: Panform.Uuid { __data["userId"] }
          }

          /// Bakery.Bread.BreadPhoto
          ///
          /// Parent Type: `BreadPhotos`
          struct BreadPhoto: Panform.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: any ApolloAPI.ParentType { Panform.Objects.BreadPhotos }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("imageUrl", String.self),
              .field("id", Panform.Uuid.self),
              .field("userId", Panform.Uuid.self),
            ] }

            var imageUrl: String { __data["imageUrl"] }
            var id: Panform.Uuid { __data["id"] }
            var userId: Panform.Uuid { __data["userId"] }
          }
        }
      }
    }
  }

}