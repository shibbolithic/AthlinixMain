import UIKit


class CreationCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        // Style the cell
        self.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 250/255, alpha: 1)
        self.layer.cornerRadius = 12
        
        // Style the plus button
        plusButton.tintColor = .systemBlue
        plusButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        
        // Style the label
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
    }
}
