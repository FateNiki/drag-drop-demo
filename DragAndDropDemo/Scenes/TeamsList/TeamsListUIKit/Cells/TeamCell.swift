//
//  TeamCell.swift
//  DragAndDropDemo
//
//  Created by Алексей Никитин on 01.09.2021.
//

import WebKit
import UIKit
import SnapKit

final class TeamCell: UITableViewCell {
  private let logoContainer = UIView()
  private let logoView = UIImageView()
  private let stackView = UIStackView()
  private let title = UILabel()
  private let subtitle = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
    configure()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    logoContainer.layer.cornerRadius = logoContainer.frame.width / 2
  }
}

extension TeamCell {
  struct Props {
    let title: String
    let subtitle: String
    let imageName: String
  }

  func render(_ props: Props) { 
    logoView.image = UIImage(named: props.imageName)
    title.text = props.title
    subtitle.text = props.subtitle
  }
}

private extension TeamCell {
  func setupViews() {
    contentView.addSubview(logoContainer)
    contentView.addSubview(stackView)
    logoContainer.addSubview(logoView)
    stackView.addArrangedSubview(title)
    stackView.addArrangedSubview(subtitle)
  }

  func configure() {
    backgroundColor = .clear
    contentView.backgroundColor = .clear

    logoContainer.backgroundColor = .white
    logoContainer.layer.masksToBounds = true

    logoView.contentMode = .scaleAspectFit
    logoView.backgroundColor = .white

    stackView.axis = .vertical
    stackView.alignment = .leading
    stackView.distribution = .fillEqually
  }

  func setupConstraints() {
    logoView.snp.makeConstraints { maker in
      maker.edges.equalTo(logoContainer).inset(8)
    }

    logoContainer.snp.makeConstraints { maker in
      maker.height.width.equalTo(64)
      maker.leading.equalTo(contentView.snp.leading).offset(8)
      maker.top.equalTo(contentView.snp.top).offset(8)
      maker.bottom.equalTo(contentView.snp.bottom).inset(8)
    }

    stackView.snp.makeConstraints { maker in
      maker.leading.equalTo(logoContainer.snp.trailing).offset(8)
      maker.trailing.equalTo(contentView.snp.trailing).offset(8)
      maker.top.equalTo(logoContainer.snp.top)
      maker.bottom.equalTo(logoContainer.snp.bottom)
    }
  }
}
