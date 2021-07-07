//
//  DetailViewController.swift
//  FetchRewards
//
//  Created by Cibi Balachander on 7/6/21.
//

import UIKit

class DetailViewController: UIViewController{
    
    
    @IBOutlet weak var myLabel : UILabel!
    @IBOutlet weak var myImageLarge : UIImageView!
    private var items : String
    private var imageURL: String
    
    init(items: String, image: String){
        self.items = items
        self.imageURL = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .gray
        myLabel.text = items
        myImageLarge.loadImage(url:URL(string: imageURL)!)
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


extension UIImageView {
    func loadImage(url: URL){
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
