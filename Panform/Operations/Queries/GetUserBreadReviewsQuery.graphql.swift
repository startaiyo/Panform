// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Panform {
  class GetUserBreadReviewsQuery: GraphQLQuery {
    static let operationName: String = "GetUserBreadReviews"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetUserBreadReviews($userId: uuid!) { bakeries( where: { breads: { _or: { breadPhotos: { userId: { _eq: $userId } } breadReviews: { userId: { _eq: $userId } } } } } ) { __typename breads { __typename breadPhotos { __typename breadId id imageUrl userId } breadReviews { __typename breadId comment id rate userId } bakeryId id name price } id } }"#
      ))

    public var userId: Uuid

    public init(userId: Uuid) {
      self.userId = userId
    }

    public var __variables: Variables? { ["userId": userId] }

    struct Data: Panform.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Panform.Objects.Query_root }
      static var __selections: [ApolloAPI.Selection] { [
        .field("bakeries", [Bakery].self, arguments: ["where": ["breads": ["_or": [
          "breadPhotos": ["userId": ["_eq": .variable("userId")]],
          "breadReviews": ["userId": ["_eq": .variable("userId")]]
        ]]]]),
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
          .field("breads", [Bread].self),
          .field("id", Panform.Uuid.self),
        ] }

        /// fetch data from the table: "breads"
        var breads: [Bread] { __data["breads"] }
        var id: Panform.Uuid { __data["id"] }

        /// Bakery.Bread
        ///
        /// Parent Type: `Breads`
        struct Bread: Panform.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { Panform.Objects.Breads }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("breadPhotos", [BreadPhoto].self),
            .field("breadReviews", [BreadReview].self),
            .field("bakeryId", Panform.Uuid.self),
            .field("id", Panform.Uuid.self),
            .field("name", String.self),
            .field("price", Int.self),
          ] }

          /// fetch data from the table: "breadPhotos"
          var breadPhotos: [BreadPhoto] { __data["breadPhotos"] }
          /// An array relationship
          var breadReviews: [BreadReview] { __data["breadReviews"] }
          var bakeryId: Panform.Uuid { __data["bakeryId"] }
          var id: Panform.Uuid { __data["id"] }
          var name: String { __data["name"] }
          var price: Int { __data["price"] }

          /// Bakery.Bread.BreadPhoto
          ///
          /// Parent Type: `BreadPhotos`
          struct BreadPhoto: Panform.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: any ApolloAPI.ParentType { Panform.Objects.BreadPhotos }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("breadId", Panform.Uuid.self),
              .field("id", Panform.Uuid.self),
              .field("imageUrl", String.self),
              .field("userId", Panform.Uuid.self),
            ] }

            var breadId: Panform.Uuid { __data["breadId"] }
            var id: Panform.Uuid { __data["id"] }
            var imageUrl: String { __data["imageUrl"] }
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
              .field("breadId", Panform.Uuid.self),
              .field("comment", String.self),
              .field("id", Panform.Uuid.self),
              .field("rate", Panform.Float8.self),
              .field("userId", Panform.Uuid.self),
            ] }

            var breadId: Panform.Uuid { __data["breadId"] }
            var comment: String { __data["comment"] }
            var id: Panform.Uuid { __data["id"] }
            var rate: Panform.Float8 { __data["rate"] }
            var userId: Panform.Uuid { __data["userId"] }
          }
        }
      }
    }
  }

}