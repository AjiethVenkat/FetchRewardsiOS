//
//  ViewController.swift
//  FetchRewards
//
//  Created by Cibi Balachander on 6/29/21.
//

import UIKit

struct APIResponse: Codable {
    var events: [Events]
}

struct Events: Codable {
    var id : Int
    var title : String
    var datetime_utc: String
    var performers: [Performers]
    
    struct Performers: Codable {
        var image: String
    }
}




class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var names = [Events]()
  
    let urlString = "https://api.seatgeek.com/2/events?client_id=MjIzOTQyMjZ8MTYyNTAwOTg1OS42MDc3MjE2"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.register(MyTableViewCell.nib(), forCellReuseIdentifier: MyTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
    }

    func fetchData(){
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _ , error in
            guard let data = data , error == nil else {
                return
            }
            do{
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from:data)
                print("jsonResult",jsonResult.events)
                DispatchQueue.main.async {
                    self.names = jsonResult.events
                    self.tableView.reloadData()
                }
            }catch{
                print(error)
            }
          
        }
        task.resume()
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell number", indexPath)
    }
}


extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let customCell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.identifier) as! MyTableViewCell
        
        customCell.configure(with: names[indexPath.row].title, imageName: names[indexPath.row].performers[0].image, dateString: names[indexPath.row].datetime_utc)
      //  let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath)
        
      //  cell.textLabel?.text = names[indexPath.row].type
       // cell.textLabel?.text = "\(names[indexPath.row].id)"
        return customCell
    }
}

