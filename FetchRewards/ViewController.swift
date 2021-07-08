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




class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet var tableView: UITableView!
    
    var names = [Events]()
    
    var favArray = [String]()
    
    let searchbar = UISearchBar()
  
    let urlString = "https://api.seatgeek.com/2/events?client_id=MjIzOTQyMjZ8MTYyNTAwOTg1OS42MDc3MjE2"
    
    func selectedFavorite(cell: UITableViewCell){
        let selectedCell = tableView.indexPath(for: cell)
        print("selectedcell",selectedCell)
        let title = names[selectedCell!.row].title
        favArray.append(title)
        print("title",favArray)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchbar.delegate = self
        view.addSubview(searchbar)
        
        tableView.register(MyTableViewCell.nib(), forCellReuseIdentifier: MyTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
     //   fetchData()
        fetchDataFirstTime()
    }
    
    override func viewDidLayoutSubviews() {
        searchbar.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.frame.width - 20, height:50)
        tableView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 55, width: view.frame.width, height: view.frame.height - 55)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchbar.resignFirstResponder()
        if let text = searchbar.text{
            names = []
            self.tableView?.reloadData()
            fetchData(query: text)
        }
    }

    func fetchData(query: String){
        guard let url = URL(string: "https://api.seatgeek.com/2/events?taxonomies.name=\(query)&client_id=MjIzOTQyMjZ8MTYyNTAwOTg1OS42MDc3MjE2") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with:  url ) { data, _ , error in
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
    
    
    func fetchDataFirstTime(){
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with:  url ) { data, _ , error in
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
        tableView.deselectRow(at: indexPath, animated: true)
        let details = names[indexPath.row].title
        let imageURL = names[indexPath.row].performers[0].image
        
        let vc = DetailViewController(items: details, image: imageURL)
       // self.navigationController?.pushViewController(vc, animated: true)
       // show(vc, sender: self)
        self.present(vc, animated: true, completion: nil)
    }
}


extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let customCell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.identifier) as! MyTableViewCell
        customCell.link = self
        customCell.configure(with: names[indexPath.row].title, imageName: names[indexPath.row].performers[0].image, dateString: names[indexPath.row].datetime_utc)
      //  let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath)
        
      //  cell.textLabel?.text = names[indexPath.row].type
       // cell.textLabel?.text = "\(names[indexPath.row].id)"
        return customCell
    }
}

