//
//  CustomLabelColorSelected.swift
//  MobaiExample
//

import UIKit


class CustomLabelView: UIView {

    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 30)
        return label
    }()

    init(text: String, padding: UIEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)) {
        super.init(frame: .zero)

        addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.left),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding.right)
        ])

        layer.backgroundColor = UIColor(red: 0.26, green: 0.264, blue: 0.28, alpha: 0.3).cgColor
        layer.cornerRadius = 25
        label.text = text
    }
    
    public func updateLabelColor(_ color: CustomLabelColorSelected) {
        switch color {
        case .green:
            label.textColor = UIColor.green
        default:
            label.textColor = UIColor.white
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
