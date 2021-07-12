//
//  DetailViewController.swift
//  FetchRewards
//
//  Created by AjiethVenkat on 7/6/21.
//

import UIKit

class DetailViewController: UIViewController{
    
    var viewController: ViewController?
    
    @IBOutlet weak var myLabel : UILabel!
    @IBOutlet weak var myImageLarge : UIImageView!
    @IBOutlet weak var myFavImage: UIButton!
    @IBOutlet weak var myDate: UILabel!
    @IBOutlet weak var myCity: UILabel!
    private var items : String
    private var imageURL: String
    private var date:String
    private var city:String
    private var id:Int
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init(items: String, image: String, date:String, city:String, id:Int){
        self.items = items
        self.imageURL = image
        self.date = date
        self.city = city
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* Fetch Coredata to show the favorites */
    func fetchCoreData(id: Int){
        
        do {
            let test = try context.fetch(FavID.fetchRequest())
            for i in test{
                if((i as AnyObject).id! == id){
                    let favImage = UIImage(named: "favorited.png")
                    myFavImage.setImage(favImage, for: .normal)
                    myFavImage.tintColor = .red
                }
            }
        }
        catch{
        }
    }
    
    /* Method to handle favorite button when clicked */
    @objc private func handleFavorite(sender:UIButton) {
        
        if(myFavImage.tintColor != .red) {
            let favImage = UIImage(named: "favorited.png")
            myFavImage.setImage(favImage, for: .normal)
            myFavImage.tintColor = .red
            let newID = FavID(context: self.context)
          //  print("sender",sender.tag)
            newID.id = Int64(sender.tag) //Save the favorited attribute using the event id
            do{
                try self.context.save()
                DispatchQueue.main.async {
                    self.viewController?.tableView.reloadData()
                }
            }catch{
            }
        }else{
            let favImage = UIImage(named: "fav.png")
            myFavImage.setImage(favImage, for: .normal)
            myFavImage.tintColor = nil
        }
        //print("Favorite is working")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        myLabel.text = items
        myLabel.font = UIFont.systemFont(ofSize: 24 , weight: .bold)
        
        myImageLarge.loadImage(url:URL(string: imageURL)!)
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "EEEE, MMM d, yyyy, h:mm a"
        
        if let date = dateFormatterGet.date(from: date) {
            // myDate.numberOfLines = 2
            myDate.text =  dateFormatterPrint.string(from: date)
            myDate.font = UIFont.systemFont(ofSize: 16 , weight: .bold)
        } else {
            print("There was an error decoding the string")
        }
        
        myCity.text = city
        
        let favImage = UIImage(named: "fav.png")
        myFavImage.setImage(favImage, for: .normal)
        myFavImage.tag = id
        myFavImage.addTarget(self, action: #selector(handleFavorite), for: .touchUpInside)
        
        fetchCoreData(id: id)
    }
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
