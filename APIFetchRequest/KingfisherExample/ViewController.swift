//
//  ViewController.swift
//  KingfisherExample
//
//  Created by Hoàng Loan on 13/03/2023.
//

import UIKit
import SDWebImage
import Kingfisher

struct DogData: Codable {
    
    var status: String
    var message: [String]
}

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var dogData : DogData?
    var dogImage = [String]()
    
    var numberOfPerRow = 2
    let insetSection = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchJSONData()
    }
    func fetchJSONData() {
        let url = URL(string: "https://dog.ceo/api/breed/hound/images")
        let dataTask = URLSession.shared.dataTask(with: url!, completionHandler: {
            data, response, error in
            guard let data = data, error == nil else {
                print("Error Occured While Accessing Data")
                return
            }
            var dogJSONData: DogData?
            do {
                dogJSONData = try JSONDecoder().decode(DogData.self, from: data)
            } catch {
                print("Error Occured While Decoding JSON Data")
            }
            self.dogData = dogJSONData
            self.dogImage = self.dogData!.message
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
        dataTask.resume()
    }
}
    
// MARK: DataSource and Delegate
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogImage.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! DogCollectionViewCell
        if let url = URL(string: dogImage[indexPath.row])  {
            // used Kingfisher
            // collectionCell.imageView.kf.setImage(with: url)
            // used SDWebImage
             collectionCell.imageView.sd_setImage(with: url)
            collectionCell.imageView.layer.cornerRadius = 25
        } else {
            collectionCell.imageView.image = UIImage(systemName: "photo")
        }
        return collectionCell
    }
}
// MARK: DelegateFlow
extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let pading = CGFloat(numberOfPerRow+1)*insetSection.left
        let widthDimention = (view.frame.width - pading) / CGFloat(numberOfPerRow)
        return CGSize(width: widthDimention, height: widthDimention)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insetSection
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return insetSection.left
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return insetSection.left
    }
}

// MARK: - CollectionViewCell

class DogCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        super.awakeFromNib()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleToFill

    }
}


