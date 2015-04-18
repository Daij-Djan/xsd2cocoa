//
//  ViewController.swift
//  addressTest_ios
//
//  Created by Dominik Pich on 10/01/15.
//  Copyright (c) 2015 Dominik Pich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSBundle.mainBundle().URLForResource("simpleTypes", withExtension: "xml")
        if(url != nil) {
            let addr = STSimpleTypesType.SimpleTypesTypeFromURL(url!)
            if(addr != nil) {
                textView.text = addr!.dictionary.description
            }
        }
    }


}

