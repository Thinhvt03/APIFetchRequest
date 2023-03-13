//
//  ViewController.swift
//  URLSession
//
//  Created by Hoàng Loan on 13/03/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let urlFire = "https://www.themealdb.com/api/json/v1/1/search.php?s=fish"
    var FoodData = [Meals]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchData()
        
    }
    
    func fetchData() {
            let url = URL(string: urlFire)
        let dataTask = URLSession.shared.dataTask(with: url!, completionHandler:  { (data, response, error) in
            guard let data = data , error == nil else {
                print("Error Occured While accessing data")
                return
            }
            var FoodJSONData: FoodsData?
            do {
                FoodJSONData = try JSONDecoder().decode(FoodsData.self, from: data)
            } catch {
                print("Error Occured while Decoder JSON")
            }
            self.FoodData = FoodJSONData!.meals
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        dataTask.resume()
    }
}

//MARK: downloadImage
extension UIImageView {
    
    func downloadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url, completionHandler:  {
            (data, response, error) in
            guard let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                  let data = data , error == nil ,
                  let image = UIImage(data: data)
            else {return}
            DispatchQueue.main.async {
                self.image = image
            }
        })
        task.resume()
    }
}

//MARK: DataSource and Delegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FoodData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.foodNameLabel.text = FoodData[indexPath.row].strMeal
        cell.foodDescription.text = FoodData[indexPath.row].strCategory
        cell.strAreaLabel.text = "StrArea: \(FoodData[indexPath.row].strArea ?? "")"
        
        if FoodData[indexPath.row].strMealThumb != nil {
            let url = URL(string: FoodData[indexPath.row].strMealThumb!)

            DispatchQueue.main.async {
                cell.foodImageView.downloadImage(from: url!)
                cell.foodImageView.contentMode = .scaleToFill
                cell.foodImageView.layer.cornerRadius = 25
            }
        } else {
            cell.foodImageView.image = UIImage(systemName: "photo")
        }
        return cell
    }
}

// MARK: - TableViewCell

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodDescription: UILabel!
    @IBOutlet weak var strAreaLabel: UILabel!
    @IBOutlet weak var starRatingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        foodImageView.contentMode = .scaleToFill
        foodImageView.image = UIImage(systemName: "photo")
    }
    
}
