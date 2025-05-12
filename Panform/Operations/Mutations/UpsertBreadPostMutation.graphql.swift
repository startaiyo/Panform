// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension Panform {
  class UpsertBreadPostMutation: GraphQLMutation {
    static let operationName: String = "UpsertBreadPost"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation UpsertBreadPost($breadID: uuid, $bakeryID: uuid!, $name: String!, $price: Int!, $comment: String!, $rate: float8!, $userId: uuid!, $imageUrls: [breadPhotos_insert_input!]!) { insert_breads_one( object: { id: $breadID bakeryId: $bakeryID name: $name price: $price breadReviews: { data: { comment: $comment, rate: $rate, userId: $userId } } breadPhotos: { data: $imageUrls } } on_conflict: { constraint: breads_pkey, update_columns: [name, price] } ) { __typename id } }"#
      ))

    public var breadID: GraphQLNullable<Uuid>
    public var bakeryID: Uuid
    public var name: String
    public var price: Int
    public var comment: String
    public var rate: Float8
    public var userId: Uuid
    public var imageUrls: [BreadPhotos_insert_input]

    public init(
      breadID: GraphQLNullable<Uuid>,
      bakeryID: Uuid,
      name: String,
      price: Int,
      comment: String,
      rate: Float8,
      userId: Uuid,
      imageUrls: [BreadPhotos_insert_input]
    ) {
      self.breadID = breadID
      self.bakeryID = bakeryID
      self.name = name
      self.price = price
      self.comment = comment
      self.rate = rate
      self.userId = userId
      self.imageUrls = imageUrls
    }

    public var __variables: Variables? { [
      "breadID": breadID,
      "bakeryID": bakeryID,
      "name": name,
      "price": price,
      "comment": comment,
      "rate": rate,
      "userId": userId,
      "imageUrls": imageUrls
    ] }

    struct Data: Panform.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { Panform.Objects.Mutation_root }
      static var __selections: [ApolloAPI.Selection] { [
        .field("insert_breads_one", Insert_breads_one?.self, arguments: [
          "object": [
            "id": .variable("breadID"),
            "bakeryId": .variable("bakeryID"),
            "name": .variable("name"),
            "price": .variable("price"),
            "breadReviews": ["data": [
              "comment": .variable("comment"),
              "rate": .variable("rate"),
              "userId": .variable("userId")
            ]],
            "breadPhotos": ["data": .variable("imageUrls")]
          ],
          "on_conflict": [
            "constraint": "breads_pkey",
            "update_columns": ["name", "price"]
          ]
        ]),
      ] }

      /// insert a single row into the table: "breads"
      var insert_breads_one: Insert_breads_one? { __data["insert_breads_one"] }

      /// Insert_breads_one
      ///
      /// Parent Type: `Breads`
      struct Insert_breads_one: Panform.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { Panform.Objects.Breads }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", Panform.Uuid.self),
        ] }

        var id: Panform.Uuid { __data["id"] }
      }
    }
  }

}