//
//  FluidsViewController.swift
//  multipeertest
//
//  Created by Joshua Qiu on 2/4/21.
//

import UIKit

class FluidsViewController: UIViewController {

    let service = AdvertisingService(type: "Fluids")
    var name: String!
    var amount: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Fluids"
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
    
    @IBAction func dose1(_ sender: Any) {
        amount = 1
    }
    
    @IBAction func dose2(_ sender: Any) {
        amount = 2
    }
    
    @IBAction func administer(_ sender: Any) {
        if amount != nil && name != nil {
            let data = "Fluids \(name!) \(amount!)".data(using: .utf8)
            print("Sending data...")
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
