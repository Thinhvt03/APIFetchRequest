//
//  ViewController.swift
//  Alamofile
//

import UIKit
import Alamofire
import AlamofireSwiftyJSON
import AlamofireImage

class ViewController: UIViewController {
   // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let reuseIdentifier = "collectionView"
    private let urlString = "https://dog.ceo/api/breed/hound/images"
    private var imageDog = [String]()
    private let numberOfRow = CGFloat(3)
    private let insetOfSection = UIEdgeInsets(top: 0, left: 5, bottom: 20, right: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchData()
    }
    
    private func fetchData() {
        guard let url = URL(string: urlString) else { return }
        Alamofire.request(url).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(_):
                let jsonData = response.result.value as! [String: Any]
                self.imageDog = jsonData["message"] as! [String]
                
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}

// MARK: - CollectionView DataSource

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageDog.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DogCollectionViewCell
        if let imageUrl = URL(string: imageDog[indexPath.row]) {
            Alamofire.request(imageUrl).responseImage(completionHandler: { (response) in
                if let image = response.result.value {
                    let scaleImage = image.af_imageScaled(to: collectionCell.imageView.bounds.size)
                    DispatchQueue.main.async {
                        collectionCell.imageView.image = scaleImage
                        collectionCell.activityIndicatiorView.stopAnimating()
                    }
                }
            })
        } else {
            collectionCell.imageView.image = UIImage(systemName: "photo")
        }
        return collectionCell
    }
}

// MARK: - CollectionView Delegate FlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = insetOfSection.left * (numberOfRow + 1)
        let widthOfRow = (collectionView.bounds.size.width - spacing) / numberOfRow
        return CGSize(width: widthOfRow, height: widthOfRow)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insetOfSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return insetOfSection.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return insetOfSection.left
    }
}

// MARK: - CollectionViewCell

class DogCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    let activityIndicatiorView = UIActivityIndicatorView(style: .medium)
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        activityIndicatiorView.frame = CGRect(origin: .zero, size: imageView.bounds.size)
        activityIndicatiorView.center = CGPoint(x: imageView.bounds.width / 2, y: imageView.bounds.height / 2)
        activityIndicatiorView.hidesWhenStopped = true
        activityIndicatiorView.startAnimating()
        imageView.addSubview(activityIndicatiorView)
    }
}



