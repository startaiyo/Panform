// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Panform {
  class GetSavedBakeriesInfoQuery: GraphQLQuery {
    static let operationName: String = "GetSavedBakeriesInfo"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetSavedBakeriesInfo($breadIds: [uuid!]) { bakeries(where: { breads: { id: { _in: $breadIds } } }) { __typename name breads(where: { id: { _in: $breadIds } }) { __typename name price id breadPhotos { __typename imageUrl id userId } breadReviews { __typename id comment rate userId } } id latitude longitude memo openAt openingDays closeAt } }"#
      ))

    public var breadIds: GraphQLNullable<[Uuid]>

    public init(breadIds: GraphQLNullable<[Uuid]>) {
      self.breadIds = breadIds
    }

    public var __variables: Variables? { ["breadIds": breadIds] }

    struct Data: Panform.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Panform.Objects.Query_root }
      static var __selections: [ApolloAPI.Selection] { [
        .field("bakeries", [Bakery].self, arguments: ["where": ["breads": ["id": ["_in": .variable("breadIds")]]]]),
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
          .field("breads", [Bread].self, arguments: ["where": ["id": ["_in": .variable("breadIds")]]]),
          .field("id", Panform.Uuid.self),
          .field("latitude", Panform.Float8.self),
          .field("longitude", Panform.Float8.self),
          .field("memo", String.self),
          .field("openAt", Int.self),
          .field("openingDays", [String].self),
          .field("closeAt", Int.self),
        ] }

        var name: String { __data["name"] }
        /// fetch data from the table: "breads"
        var breads: [Bread] { __data["breads"] }
        var id: Panform.Uuid { __data["id"] }
        var latitude: Panform.Float8 { __data["latitude"] }
        var longitude: Panform.Float8 { __data["longitude"] }
        var memo: String { __data["memo"] }
        var openAt: Int { __data["openAt"] }
        var openingDays: [String] { __data["openingDays"] }
        var closeAt: Int { __data["closeAt"] }

        /// Bakery.Bread
        ///
        /// Parent Type: `Breads`
        struct Bread: Panform.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { Panform.Objects.Breads }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("name", String.self),
            .field("price", Int.self),
            .field("id", Panform.Uuid.self),
            .field("breadPhotos", [BreadPhoto].self),
            .field("breadReviews", [BreadReview].self),
          ] }

          var name: String { __data["name"] }
          var price: Int { __data["price"] }
          var id: Panform.Uuid { __data["id"] }
          /// fetch data from the table: "breadPhotos"
          var breadPhotos: [BreadPhoto] { __data["breadPhotos"] }
          /// An array relationship
          var breadReviews: [BreadReview] { __data["breadReviews"] }

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

          /// Bakery.Bread.BreadReview
          ///
          /// Parent Type: `BreadReviews`
          struct BreadReview: Panform.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: any ApolloAPI.ParentType { Panform.Objects.BreadReviews }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", Panform.Uuid.self),
              .field("comment", String.self),
              .field("rate", Panform.Float8.self),
              .field("userId", Panform.Uuid.self),
            ] }

            var id: Panform.Uuid { __data["id"] }
            var comment: String { __data["comment"] }
            var rate: Panform.Float8 { __data["rate"] }
            var userId: Panform.Uuid { __data["userId"] }
          }
        }
      }
    }
  }

}