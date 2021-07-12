//
//  ViewController.swift
//  FetchRewards
//
//  Created by AjiethVenkat on 6/29/21.
//

import UIKit
import CoreData

/* Struct Method to get the objects of API from SeatGeek*/
struct APIResponse: Codable {
    var events: [Events]
}

struct Events: Codable {
    var id : Int
    var title : String
    var datetime_utc: String
    var performers: [Performers]
    var venue: Venue
    
    struct Performers: Codable {
        var image: String
    }
    
    struct Venue: Codable {
        var city: String
    }
}

/* This is root View controller*/
class ViewController: UIViewController, UISearchBarDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //Context for coredata
    
    @IBOutlet var tableView: UITableView!
    
    var names = [Events]()
    
    var favArray = [String]()
    
    let searchbar = UISearchBar()
    
    let urlString = "https://api.seatgeek.com/2/events?client_id=MjIzOTQyMjZ8MTYyNTAwOTg1OS42MDc3MjE2"
    
    /* Function for Adding and Deleting from coredata */
//    func selectedFavorite(cell: UITableViewCell){
//        let selectedCell = tableView.indexPath(for: cell)
//        //  print("selectedcell",selectedCell!)
//        let title = names[selectedCell!.row].id
//        let newID = FavID(context: self.context) //FavID is dataModal
//        newID.id = Int64(title) // Adding a 'id' to the coreData
//        do{
//            try self.context.save()
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }catch{
//        }
//    }
    
//    func deselectedFavorite(cell: UITableViewCell){
//        let deselectedCell = tableView.indexPath(for: cell)
//
//        let id = names[deselectedCell!.row].id
//        let intTypeCast = id
//        print("delete", intTypeCast, deselectedCell!.row)
//
//            self.context.delete(names[deselectedCell!.row].id)
//                do {
//                    let test = try context.fetch(FavID.fetchRequest())
//                    for i in test{
//                        if(i == Int64(id){
//                            self.context.delete(i as! NSManagedObject)
//                        }
//                    }
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//                }
//                catch{
//                }
//    }
    
    /* Function to clear keyboard after typing */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchbar.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchbar.delegate = self
        searchbar.showsCancelButton = true
        
        view.addSubview(searchbar)
        
        tableView.register(MyTableViewCell.nib(), forCellReuseIdentifier: MyTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
   
        fetchDataFirstTime()
    }
    
    /* Adding view for tableview and searchbar */
    override func viewDidLayoutSubviews() {
        searchbar.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.frame.width - 20, height:50)
        tableView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 55, width: view.frame.width, height: view.frame.height - 55)
    }
    
    /* Search a query by clicking the search button */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchbar.resignFirstResponder()
        if let text = searchbar.text{
            names = []
            self.tableView?.reloadData()
            fetchData(query: text)
        }
    }
    
    /* Get data into the tableview after a query is searched */
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
    
    /* Getting data into the tableview when user launches the app first time */
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

/* Extension of the main class for tableview attributes */
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        // print("Cell number", indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        let details = names[indexPath.row].title
        let imageURL = names[indexPath.row].performers[0].image
        let time = names[indexPath.row].datetime_utc
        let city = names[indexPath.row].venue.city
        let id = names[indexPath.row].id
        let vc = DetailViewController(items: details, image: imageURL, date: time, city:city, id:id) // Adding arugments to the DetailViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let customCell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.identifier) as! MyTableViewCell
        customCell.link = self
        customCell.configure(with: names[indexPath.row].title, imageName: names[indexPath.row].performers[0].image, dateString: names[indexPath.row].datetime_utc, id: names[indexPath.row].id, city: names[indexPath.row].venue.city)
        return customCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

