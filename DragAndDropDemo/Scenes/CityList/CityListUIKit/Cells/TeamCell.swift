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
  private let logoView = UIImageView()

  init() {
    super.init(style: .default, reuseIdentifier: "TeamCell")
    setupViews()
    configure()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
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
  }
}

private extension TeamCell {
  func setupViews() {
    contentView.addSubview(logoView)
  }

  func configure() {
  }

  func setupConstraints() {
    logoView.snp.makeConstraints { maker in
      maker.height.width.equalTo(64)
      maker.leading.equalTo(contentView.snp.leading).offset(4)
      maker.top.equalTo(contentView.snp.top).offset(4)
      maker.bottom.equalTo(contentView.snp.bottom).inset(4)
    }
  }
}
