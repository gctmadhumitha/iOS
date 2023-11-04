import UIKit

/// A view controller that displays information for a given `Place`.
///
public class PlaceViewController: UIViewController {
  public let place: Place

  public init(place: Place) {
    self.place = place
    super.init(nibName: nil, bundle: nil)
  }
  
  private lazy var imageView : UIImageView = {
    let image = UIImageView()
    image.contentMode = .scaleAspectFit
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()
  
  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.text = ""
    label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.text = ""
    label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var ratingLabel: UILabel = {
    let label = UILabel()
    label.text = ""
    label.font = UIFont.preferredFont(forTextStyle: .caption2)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var addressLabel: UILabel = {
    let label = UILabel()
    label.text = ""
    label.font = UIFont.preferredFont(forTextStyle: .caption1)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(imageView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(descriptionLabel)
    contentView.addSubview(ratingLabel)
    contentView.addSubview(addressLabel)
    view.addSubview(contentView)
    setupUI()
  }
  
  func setupUI(){
    
    nameLabel.text = place.name
    addressLabel.text = place.address
    ratingLabel.text = String(place.reviews)
    
    if let imageUrl = place.imageURL {
      ImageLoader.loadImage(forURL: imageUrl) { image in
        DispatchQueue.main.async { [weak self] in
          self?.imageView.image = image
        }
      }
      
    }
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      imageView.heightAnchor.constraint(equalToConstant: 200),
      
      contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      contentView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
      contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      
      descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
      
      addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      addressLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
      
      ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      ratingLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10),
      
    ])
  }
  
}
