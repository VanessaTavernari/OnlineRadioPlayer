//
//  MoreInformation.swift
//  PlayMusic
//
//  Created by Vanessa Tavares Tavernari on 23/02/2022.
//

import UIKit

class MoreInformation: UIViewController {

    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var buttonCall: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickToCall(_ sender: Any) {
    
        if let url = URL(string: "tel://\(phoneTextField.text!)"),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
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

