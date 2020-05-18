//
//  CollectionFooterView.swift
//  CollectionTest
//
//  Created by Алексей Пархоменко on 15.05.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

protocol HideButtonsDelegate: class {
    func hide()
}

class CollectionFooterView: UICollectionReusableView {
    
    let unlockButton = UIButton(type: .system)
    let restoreButton = UIButton(type: .system)
    let checkLabel = UILabel()
    var buttonsStackView: UIStackView!
    
    var appsCollectionView: UICollectionView! = nil
    private let itemsPerRow: CGFloat = 3
    private let sectionInserts = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    weak var delegate: HideButtonsDelegate?
    
    var buttonsOnConstraint: NSLayoutConstraint!
    var buttonsOffConstraint: NSLayoutConstraint!
    
    static let reuseId = "CollectionFooterView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupElements()
        setupConstraints()
    }
    
    // MARK: - Actions
    @objc func unlockButtonTapped() {
        hideButtons()
    }
    
    @objc func restoreButtonTapped() {
        hideButtons()
    }
    
    func hideButtons() {
        buttonsStackView.removeFromSuperview()
        buttonsOnConstraint.isActive = false
        buttonsOffConstraint.isActive = true
        delegate?.hide()
    }
    
    // MARK: - Setup View
    func setupElements() {
        unlockButton.setTitle("Unlock this Sticker Pack for 0.99$", for: .normal)
        restoreButton.setTitle("Restore Purchase", for: .normal)
        checkLabel.text = "Check out some more"
        
        unlockButton.layer.cornerRadius = 8
        unlockButton.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
        unlockButton.setTitleColor(.white, for: .normal)
        
        restoreButton.layer.cornerRadius = 8
        restoreButton.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        restoreButton.setTitleColor(.white, for: .normal)
        
        checkLabel.backgroundColor = .black
        checkLabel.textColor = .white
        checkLabel.textAlignment = .center
        
        unlockButton.addTarget(self, action: #selector(unlockButtonTapped), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
        
        appsCollectionView = UICollectionView(frame: bounds, collectionViewLayout: UICollectionViewFlowLayout())
        appsCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        appsCollectionView.backgroundColor = .white
        
        appsCollectionView.delegate = self
        appsCollectionView.dataSource = self
        
        appsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        
        if let layout = appsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
    
    // MARK: - Setup Constraints
    func setupConstraints() {
        checkLabel.translatesAutoresizingMaskIntoConstraints = false
        appsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonsStackView = UIStackView(arrangedSubviews: [unlockButton, restoreButton])
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 24
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(buttonsStackView)
        addSubview(checkLabel)
        addSubview(appsCollectionView)
        
        unlockButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        restoreButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
        
        buttonsOffConstraint = checkLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24)
        buttonsOffConstraint.isActive = false
        
        buttonsOnConstraint = checkLabel.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 36)
        buttonsOnConstraint.isActive = true
        NSLayoutConstraint.activate([
            checkLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            checkLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            checkLabel.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        NSLayoutConstraint.activate([
            appsCollectionView.topAnchor.constraint(equalTo: checkLabel.bottomAnchor, constant: 24),
            appsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            appsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            appsCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -64)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CollectionFooterView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionFooterView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = (17 * (itemsPerRow - 1)) + sectionInserts.left + sectionInserts.left
        let availableWidth = frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        print("widthPerItem: \(widthPerItem)")
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
    
}


