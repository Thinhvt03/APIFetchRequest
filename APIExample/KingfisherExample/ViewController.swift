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

    @IBOutlet weak var dogCollectionView: UICollectionView!
    private var dogData : DogData?
    private var dogImage = [String]()
    private let numberOfPerRow = CGFloat(2)
    private let insetSection = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    private let urlString = "https://dog.ceo/api/breed/hound/images"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogCollectionView.dataSource = self
        dogCollectionView.delegate = self
        fetchJSONData()
    }
    func fetchJSONData() {
        guard let url = URL(string: urlString) else { return }
        let dataTask = URLSession.shared.dataTask(with: url, completionHandler: {
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
                self.dogCollectionView.reloadData()
            }
        })
        dataTask.resume()
    }
}
    
// MARK: DataSource and Delegate

extension ViewController: UICollectionViewDataSource {
    private func setupDownloadImage(imageView: UIImageView, url: URL) {
        imageView.kf.indicatorType = .activity
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: 20)
        imageView.kf.setImage(with: url,
                              options: [
                                .processor(processor),
                                .scaleFactor(UIScreen.main.scale),
                                .transition(.fade(1.0)),
                                .diskCacheExpiration(.days(30))
                              ],
                              completionHandler: {
            result in
            switch result {
            case .success(let value):
                imageView.image = value.image
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogImage.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! DogCollectionViewCell
        if let url = URL(string: dogImage[indexPath.row])  {
            // used Kingfisher
            setupDownloadImage(imageView: collectionCell.imageView, url: url)
            // used SDWebImage
//            collectionCell.imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
//            collectionCell.imageView.sd_imageTransition = SDWebImageTransition.fade(duration: 1.0)
//            collectionCell.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"))
//            collectionCell.imageView.layer.cornerRadius = 25
        } else {
            collectionCell.imageView.image = UIImage(systemName: "photo")
        }
        return collectionCell
    }
}
// MARK: - DelegateFlow

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = (numberOfPerRow + 1) * insetSection.left
        let widthOfRow = (collectionView.frame.width - spacing) / (numberOfPerRow)
        return CGSize(width: widthOfRow, height: widthOfRow)
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
        imageView.contentMode = .scaleToFill
    }
}


