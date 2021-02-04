//
//  DrugsViewController.swift
//  multipeertest
//
//  Created by Joshua Qiu on 2/4/21.
//

import UIKit

class DrugsViewController: UIViewController {

    let service = AdvertisingService(type: "Drugs")
    var amount: Int!
    var name: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Drugs"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func colloids(_ sender: Any) {
        name = "Colloids"
    }
    
    @IBAction func crystalloids(_ sender: Any) {
        name = "Crystalloids"
    }
    
    @IBAction func hartmann(_ sender: Any) {
        name = "Hartmann"
    }
    
    @IBAction func lactate(_ sender: Any) {
        name = "Ringer's Lactate"
    }
    
    @IBAction func saline(_ sender: Any) {
        name = "Saline"
    }
    
    @IBAction func dose3(_ sender: Any) {
        amount = 3
    }
    
    @IBAction func dose6(_ sender: Any) {
        amount = 6
    }
    
    @IBAction func dose12(_ sender: Any) {
        amount = 12
    }
    
    @IBAction func administer(_ sender: Any) {
        if amount != nil && name != nil {
            let data = "Drugs \(name!) \(amount!)".data(using: .utf8)
            service.send(data: data!)
        }else{
            print("No options selected")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
