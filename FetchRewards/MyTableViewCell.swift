//
//  MyTableViewCell.swift
//  FetchRewards
//
//  Created by Cibi Balachander on 6/30/21.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    static let identifier = "MyTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MyTableViewCell", bundle: nil)
    }
    
    public func configure(with title: String, imageName: String, dateString:String) {
        myLabel.text = title
        myLabel.numberOfLines = 2
      //  let dateConversion = Date()
        let utcDateFormatter = DateFormatter()
        utcDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        myDate.text = dateString//utcDateFormatter.date(from: dateString)
     //   myImageView.image = UIImage(systemName: imageName)
        myImageView.load(url: URL(string: imageName)!)
    }

    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var myLabel: UILabel!
    @IBOutlet var myDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

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
