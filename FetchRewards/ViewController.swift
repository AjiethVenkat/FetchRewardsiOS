//
//  ViewController.swift
//  FetchRewards
//
//  Created by Cibi Balachander on 6/29/21.
//

import UIKit

struct APIResponse: Decodable {
    let events: [Events]
}

struct Events: Decodable {
    let id : Int
    let type : String
}


class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var names:[Events] = []
    let urlString = "https://api.seatgeek.com/2/events?client_id=MjIzOTQyMjZ8MTYyNTAwOTg1OS42MDc3MjE2"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
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
                print("jsonResult",jsonResult)
                DispatchQueue.main.async {
                    self.names = jsonResult.events
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath)
        
        cell.textLabel?.text = names[indexPath.row].type
        return cell
    }
}

