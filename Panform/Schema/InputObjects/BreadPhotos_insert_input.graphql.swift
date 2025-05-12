// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension Panform {
  /// input type for inserting data into table "breadPhotos"
  struct BreadPhotos_insert_input: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      breadId: GraphQLNullable<Uuid> = nil,
      id: GraphQLNullable<Uuid> = nil,
      imageUrl: GraphQLNullable<String> = nil,
      userId: GraphQLNullable<Uuid> = nil
    ) {
      __data = InputDict([
        "breadId": breadId,
        "id": id,
        "imageUrl": imageUrl,
        "userId": userId
      ])
    }

    var breadId: GraphQLNullable<Uuid> {
      get { __data["breadId"] }
      set { __data["breadId"] = newValue }
    }

    var id: GraphQLNullable<Uuid> {
      get { __data["id"] }
      set { __data["id"] = newValue }
    }

    var imageUrl: GraphQLNullable<String> {
      get { __data["imageUrl"] }
      set { __data["imageUrl"] = newValue }
    }

    var userId: GraphQLNullable<Uuid> {
      get { __data["userId"] }
      set { __data["userId"] = newValue }
    }
  }

}