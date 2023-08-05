//
//  File.swift
//
//
//  Created by Jordan Howlett on 8/4/23.
//

import Foundation

public enum SVDBError: Error {
    case collectionAlreadyExists
}

public enum CollectionError: Error {
    case fileNotFound
    case loadFailed(String)
}
