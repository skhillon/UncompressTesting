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

    guard let fileData = try? Data(contentsOf: url, options: .uncached) else {
      return
    }

    guard let archive = Archive(data: fileData, accessMode: .create) else {
      return
    }

    guard let entry = archive["data.json"] else {
        return
    }

    do {
      var uncompressedData = Data()
      _ = try archive.extract(entry) { data in
        uncompressedData.append(data)
      }
      let json = try JSONSerialization.jsonObject(with: uncompressedData, options: []) as? [String: Any]
      print(json)
    } catch {
        print("Extracting entry from archive failed with error:\(error)")
    }

  }


}

