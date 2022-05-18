//
//  ViewController.swift
//  URLRequest
//
//  Created by Наталья Булгакова on 30.03.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var cellImageView = UIImageView()
    var cellLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cellImageView)
        contentView.addSubview(cellLabel)
        
        configUICell()
        configUIImageView()
        configUILabel()
        
        addConstrainsImageView()
        addConstrainsCellLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUICell(){
        self.backgroundColor = .lightGray
    }
    
    private func configUIImageView(){
        cellImageView.layer.cornerRadius = 10
        cellImageView.contentMode = .scaleAspectFill
        cellImageView.clipsToBounds = true
    }
    
    private func configUILabel(){
        cellLabel.numberOfLines = 0
        cellLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func addConstrainsImageView(){
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            cellImageView.heightAnchor.constraint(equalToConstant: 100),
            cellImageView.widthAnchor.constraint(equalTo: cellImageView.heightAnchor, multiplier: 14/9)
        ])
    }
    
    private func addConstrainsCellLabel(){
        cellLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cellLabel.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: 20),
            cellLabel.heightAnchor.constraint(equalToConstant: 110),
            cellLabel.trailingAnchor.constraint(equalTo:contentView.trailingAnchor, constant: -20)
        ])
    }
    
    func setCellContent(labelText: String) {
        self.cellLabel.text = labelText
    }
    
    func setImageData(_ data: Data) {
        self.cellImageView.image = UIImage(data: imageData)?.scaled(to: 70)
    }
}
extension UIImage {
    func scaled(to maxSize: CGFloat) -> UIImage? {
        let aspectRatio: CGFloat = min(maxSize / size.width, maxSize / size.height)
        let newSize = CGSize(width: size.width * aspectRatio, height: size.height * aspectRatio)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { context in
            draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        }
    }
}

