//
//  BedsideViewController.swift
//  multipeertest
//
//  Created by Joshua Qiu on 1/21/21.
//

import UIKit

class BedsideViewController: UIViewController {

    let service = AdvertisingService(type: "Bedside Monitor")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bedside Monitor"

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("\(title!) loaded")
        
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        
        print("\(title!) deloaded")
        service.signal()

    }
    
    @IBAction func signal(_ sender: Any) {
        
        print("Signal")
        
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
