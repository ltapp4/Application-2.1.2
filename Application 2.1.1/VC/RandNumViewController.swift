//
//  RandNumViewController.swift
//  Application 2.1.1
//
//  Created by Lauren Tapp on 9/13/21.
//

import UIKit

class RandNumViewController: UIViewController {

    @IBOutlet weak var numGen: UIButton!
    @IBOutlet weak var label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func numGenTapped(_ sender: Any) {
        let random = Int(arc4random_uniform(101))
        label.text = String(random)
    
        
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
