//
//  DFViewController.swift
//  multipeertest
//
//  Created by Joshua Qiu on 1/21/21.
//

import UIKit

class DFViewController: UIViewController {

    let service = AdvertisingService(type: "Drugs and Fluids")
    var fluid = "none"
    var volume = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Drugs and Fluids"

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("\(title!) loaded")
        
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        
        print("\(title!) deloaded")
        
    }
    @IBAction func colloidSelect(_ sender: Any) {
        fluid = "colloids"
        //print("colloids")
    }
    @IBAction func crystalSelect(_ sender: Any) {
        fluid = "crystalloids"
        //print("crys")
    }
    @IBAction func hartmannSelect(_ sender: Any) {
        fluid = "hartmann"
        //print("hartmann")
    }
    @IBAction func ringerSelect(_ sender: Any) {
        fluid = "ringer's lactate"
        //print("ringer")
    }
    @IBAction func salineSelect(_ sender: Any) {
        fluid = "saline"
        //print("saline")
    }
    @IBAction func LSelect(_ sender: Any) {
        volume = 1
    }
    @IBAction func L2Select(_ sender: Any) {
        volume = 2
    }
    @IBAction func administerSelect(_ sender: Any) {
        print("administering \(volume)L of \(fluid)")
    }
    
    
    @IBAction func signal(_ sender: Any) {
        
        print("Signal")
        service.signal()

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
