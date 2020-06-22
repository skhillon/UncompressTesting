//
//  ViewController.swift
//  UncompressTesting
//
//  Created by Sarthak Khillon on 6/21/20.
//  Copyright © 2020 Sarthak Khillon. All rights reserved.
//

import ZIPFoundation
import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    guard let url = Bundle.main.url(forResource: "data", withExtension: "zip") else {
      return
    }

    // Load archive file contents as `Data`, which is the same thing you would get from the server.
    guard let fileData = try? Data(contentsOf: url, options: .uncached) else {
      return
    }

    guard let archive = Archive(data: fileData, accessMode: .create) else {
      return
    }

    // The archive should have just 1 file, which we want to extract.
    guard let entry = archive["data.json"] else {
      // === ERROR: This guard block is entered. ===
      return
    }

    do {
      // Combine all chunks into one, which can then be JSON serialized.
      var uncompressedData = Data()
      _ = try archive.extract(entry) { chunk in uncompressedData.append(chunk) }

      // Convert to JSON and print to make sure it looks ok.
      let json = try JSONSerialization.jsonObject(with: uncompressedData, options: []) as? [String: Any]
      print(json as Any)
    } catch {
      print("Extracting entry from archive failed with error:\(error)")
    }

  }

}

