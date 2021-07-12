//
//  MyTableViewCell.swift
//  FetchRewards
//
//  Created by AjiethVenkat on 6/30/21.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static let identifier = "MyTableViewCell"
    var link: ViewController?
    
    static func nib() -> UINib {
        return UINib(nibName: "MyTableViewCell", bundle: nil)
    }
    
    /* Fetch data from coredata to get the favorites using event 'id'*/
    func fetchCoreData(id: Int){
        do {
            let test = try context.fetch(FavID.fetchRequest())
            for i in test{
                if((i as AnyObject).id! == id){
                    let favImage = UIImage(named: "favorited.png")
                    myFavoriteButton.setImage(favImage, for: .normal)
                    myFavoriteButton.tintColor = .red
                }
            }
        }
        catch{
        }
    }
    
    public func configure(with title: String, imageName: String, dateString:String, id:Int, city:String) {
        
        myLabel.text = title
        myLabel.font = UIFont.systemFont(ofSize: 18 , weight: .bold)
        
        myCityLabel.text = city
       
        myImageView.load(url: URL(string: imageName)!)
        
        fetchCoreData(id: id)
        
        /* Convert date from API to required date format */
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "EEEE, MMM d, yyyy, h:mm a"
        
        if let date = dateFormatterGet.date(from: dateString) {
            myDate.numberOfLines = 2
            myDate.text =  dateFormatterPrint.string(from: date)
        } else {
            print("There was an error decoding the string")
        }
    }
    
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var myLabel: UILabel!
    @IBOutlet var myDate: UILabel!
    @IBOutlet var myFavoriteButton: UIButton!
    @IBOutlet var myCityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

/* Extension for UIImageView to get the image from the url given */
extension UIImageView {
    func load(url: URL){
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
