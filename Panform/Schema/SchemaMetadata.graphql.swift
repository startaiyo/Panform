// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

protocol Panform_SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == Panform.SchemaMetadata {}

protocol Panform_InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == Panform.SchemaMetadata {}

protocol Panform_MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == Panform.SchemaMetadata {}

protocol Panform_MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == Panform.SchemaMetadata {}

extension Panform {
  typealias SelectionSet = Panform_SelectionSet

  typealias InlineFragment = Panform_InlineFragment

  typealias MutableSelectionSet = Panform_MutableSelectionSet

  typealias MutableInlineFragment = Panform_MutableInlineFragment

  enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
      switch typename {
      case "bakeries": return Panform.Objects.Bakeries
      case "breadPhotos": return Panform.Objects.BreadPhotos
      case "breadReviews": return Panform.Objects.BreadReviews
      case "breads": return Panform.Objects.Breads
      case "mutation_root": return Panform.Objects.Mutation_root
      case "query_root": return Panform.Objects.Query_root
      case "users": return Panform.Objects.Users
      default: return nil
      }
    }
  }

  enum Objects {}
  enum Interfaces {}
  enum Unions {}

}