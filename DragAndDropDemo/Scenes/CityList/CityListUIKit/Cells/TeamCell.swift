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
    title.text = props.title
    subtitle.text = props.subtitle
  }
}

private extension TeamCell {
  func setupViews() {
    contentView.addSubview(logoView)
    contentView.addSubview(stackView)
    stackView.addArrangedSubview(title)
    stackView.addArrangedSubview(subtitle)
  }

  func configure() {
    stackView.axis = .vertical
    stackView.alignment = .leading
    stackView.distribution = .fill
  }

  func setupConstraints() {
    logoView.snp.makeConstraints { maker in
      maker.height.width.equalTo(64)
      maker.leading.equalTo(contentView.snp.leading).offset(4)
      maker.top.equalTo(contentView.snp.top).offset(4)
      maker.bottom.equalTo(contentView.snp.bottom).inset(4)
    }

    stackView.snp.makeConstraints { maker in
      maker.leading.equalTo(logoView.snp.trailing).offset(8)
      maker.trailing.equalTo(contentView.snp.trailing).offset(4)
      maker.top.equalTo(logoView.snp.top)
      maker.bottom.equalTo(logoView.snp.bottom)
    }
  }
}
