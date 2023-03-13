//
//  ViewController.swift
//  Alamofile
//
//  Created by Hoàng Loan on 13/03/2023.
//

import UIKit
import Alamofire
import AlamofireImage

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var DogImageList = [String: Any]()
    var imageDog = [String]()
    
    var numberOfPerRow = 3
    let insetSection = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchData()
    }
    
   private func fetchData() {
        let urlFire = "https://dog.ceo/api/breed/hound/images"
        Alamofire.request(urlFire).responseJSON(completionHandler: { (response) in
            switch response.result {
                
            case .success(_):
                let JSONData = response.result.value as! [String : Any]
                self.DogImageList = JSONData
                self.imageDog = JSONData["message"] as! [String]
                
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                }
               
            case .failure(let error):
                print("Error Occured: \(error.localizedDescription)")
            }
        })
    }
}

// MARK: - DataSource and Delegate

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDog.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DogCell
        
        if let imageUrl = URL(string: imageDog[indexPath.row]) {
            Alamofire.request(imageUrl).responseImage(completionHandler: { (response) in
                let image = response.result.value

                DispatchQueue.main.async {
                    cell.imageView.image = image
                }
            })
        } else {
            cell.imageView.image = UIImage(systemName: "photo")
        }
        return cell
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
class DogCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(systemName: "photo")
    }
    
}

