//
//  EPUBArchiveService.swift
//  EPUBKit
//
//  Created by Witek Bobrowski on 30/06/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation
import Zip

protocol EPUBArchiveService {
  func unarchive(archive url: URL) throws -> URL
}

class EPUBArchiveServiceImplementation: EPUBArchiveService {

  init() {
    Zip.addCustomFileExtension("epub")
  }

  func unarchive(archive url: URL) throws -> URL {
    var destination: URL
    do {
      let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "tmp"
      var epubFileName = url
      epubFileName.deletePathExtension()
      let tt = try FileManager.default.url(
          for: .documentDirectory,
           in: .userDomainMask,
           appropriateFor: nil,
             create: true)
        .appendingPathComponent(appName, isDirectory: true)
        .appendingPathComponent(epubFileName.lastPathComponent, isDirectory: true)
      try Zip.unzipFile(
        url,
        destination: tt,
        overwrite: true,
        password: nil,
        progress: nil,
        fileOutputHandler: nil)
      destination = tt
    } catch {
      throw EPUBParserError.unzipFailed(reason: error)
    }
    return destination
  }

}
