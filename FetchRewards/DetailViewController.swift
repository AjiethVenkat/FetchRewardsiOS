//
//  DetailViewController.swift
//  FetchRewards
//
//  Created by Cibi Balachander on 7/6/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var myLabel : UILabel!
    private var items =  ""
    
    init(items: String){
        self.items = items
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myLabel.text = items
        // Do any additional setup after loading the view.
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
