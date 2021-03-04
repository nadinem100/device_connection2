//
//  MainViewController.swift
//  multipeertest
//
//  Created by Joshua Qiu on 1/21/21.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Setup"
        self.view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        // Do any additional setup after loading the view.
        var view = UILabel()

        view.frame = CGRect(x: 0, y: 0, width: 738, height: 291)

        view.backgroundColor = .white


        let image0 = UIImage(named: "ContextShot.png")?.cgImage

        let layer0 = CALayer()

        layer0.contents = image0

        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1.13, b: 0, c: 0, d: 1.91, tx: -0.09, ty: -0.73))

        layer0.bounds = view.bounds

        layer0.position = view.center

        view.layer.addSublayer(layer0)



        var parent = self.view!

        parent.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.widthAnchor.constraint(equalToConstant: 738).isActive = true

        view.heightAnchor.constraint(equalToConstant: 291).isActive = true

        view.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 16).isActive = true

        view.topAnchor.constraint(equalTo: parent.topAnchor, constant: 69).isActive = true

        var view2 = UILabel()

        view2.frame = CGRect(x: 0, y: 0, width: 735, height: 80)

        view2.backgroundColor = .white


        view2.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor

        parent.addSubview(view2)

        view2.translatesAutoresizingMaskIntoConstraints = false

        view2.heightAnchor.constraint(equalToConstant: 80).isActive = true

        view2.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 16).isActive = true

        view2.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -17).isActive = true

        view2.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -584).isActive = true

        var view3 = UILabel()

        view3.frame = CGRect(x: 0, y: 0, width: 194, height: 22)

        view3.backgroundColor = .white

        view3.textColor = UIColor(red: 0.122, green: 0.122, blue: 0.122, alpha: 1)

        view3.font = UIFont(name: "Lato-Bold", size: 18)

        var paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineHeightMultiple = 1


        // Line height: 22 pt

        // (identical to box height)


        view3.attributedText = NSMutableAttributedString(string: "My Laerdal subscription", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])

        var parent3 = view2
        parent3.addSubview(view3)

        view3.translatesAutoresizingMaskIntoConstraints = false

        view3.heightAnchor.constraint(equalToConstant: 22).isActive = true

        view3.leadingAnchor.constraint(equalTo: parent3.leadingAnchor, constant: 24).isActive = true

        view3.trailingAnchor.constraint(equalTo: parent3.trailingAnchor, constant: 0).isActive = true

        view3.topAnchor.constraint(equalTo: parent3.topAnchor, constant: 18).isActive = true
        
        var view4 = UILabel()

        view4.frame = CGRect(x: 0, y: 0, width: 639, height: 20)

        view4.backgroundColor = .white


        view4.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)

        view4.font = UIFont(name: "Lato-Regular", size: 14)

        var paragraphStyle2 = NSMutableParagraphStyle()

        paragraphStyle2.lineHeightMultiple = 1.17


        // Line height: 20 pt

        // (identical to box height)


        view4.attributedText = NSMutableAttributedString(string: "Laerdal Connect", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle2])


        parent3.addSubview(view4)

        view4.translatesAutoresizingMaskIntoConstraints = false

        view4.heightAnchor.constraint(equalToConstant: 20).isActive = true

        view4.leadingAnchor.constraint(equalTo: parent3.leadingAnchor, constant: 24).isActive = true

        view4.trailingAnchor.constraint(equalTo: parent3.trailingAnchor, constant: 0).isActive = true

        view4.topAnchor.constraint(equalTo: parent3.topAnchor, constant: 42).isActive = true



    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("\(title!) loaded")
        
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        
        print("\(title!) deloaded")
        
    }

    @IBAction func managerButton(_ sender: Any) {
        
        print("Manager button clicked")
        
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
