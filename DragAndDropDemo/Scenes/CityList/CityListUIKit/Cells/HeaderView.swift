//
//  HeaderView.swift
//  DragAndDropDemo
//
//  Created by Алексей Никитин on 12.09.2021.
//

import UIKit
import SnapKit

final class HeaderView: UIView {
  let imageView: UIImageView = UIImageView()
  let title: UILabel = UILabel()

  struct Props {
    let title: String
    let imageName: String
  }

  init() {
    super.init(frame: .zero)
    setupViews()
    setupConstraints()
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func render(props: Props) {
    title.text = props.title
    imageView.image = UIImage(named: props.imageName)
  }
}

private extension HeaderView {
  func setupViews() {
    addSubview(imageView)
    addSubview(title)
  }

  func configure() {
    imageView.contentMode = .scaleAspectFit

  }

  func setupConstraints() {
    imageView.snp.makeConstraints { maker in
      maker.height.width.equalTo(64)
      maker.right.equalToSuperview().inset(16)
      maker.top.equalToSuperview().offset(8)
      maker.bottom.equalToSuperview().inset(8)
    }

    title.snp.makeConstraints { maker in
      maker.left.equalToSuperview().offset(16)
      maker.right.greaterThanOrEqualTo(imageView.snp.left).inset(8)
      maker.centerY.equalTo(imageView.snp.centerY)
      maker.height.equalTo(20)
    }
  }
}
