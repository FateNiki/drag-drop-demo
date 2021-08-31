//
//  TeamCell.swift
//  DragAndDropDemo
//
//  Created by Алексей Никитин on 01.09.2021.
//

import WebKit
import UIKit

final class TeamCell: UITableViewCell {
  private let logoView = UIWebView()

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
    logoView.stopLoading()
  }
}

extension TeamCell {
  struct Props {
    let title: String
    let subtitle: String
    let imageUrl: URL
  }

  func render(_ props: Props) {
    logoView.load(URLRequest(url: props.imageUrl))
  }
}

private extension TeamCell {
  func setupViews() {
    contentView.addSubview(logoView)
  }

  func configure() {
    logoView.translatesAutoresizingMaskIntoConstraints = false
    logoView.delegate = self

    // disable scrolling
    logoView.scalesPageToFit = true
    logoView.scrollView.isScrollEnabled = false
    logoView.scrollView.backgroundColor = .clear
    logoView.contentMode = .scaleAspectFit
    logoView.backgroundColor = UIColor.clear
  }

  func setupConstraints() {
    NSLayoutConstraint.activate([
      logoView.heightAnchor.constraint(equalToConstant: 64),
      logoView.widthAnchor.constraint(equalToConstant: 64),
      logoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
      logoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
      logoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
    ])
  }
}

extension TeamCell: UIWebViewDelegate {

  func webViewDidFinishLoad(_ webView: UIWebView) {
    let contentSize = webView.scrollView.contentSize
    let webViewSize = webView.bounds.size
    let scaleFactor = webViewSize.width / contentSize.width

    // scale the svg appropriately
    webView.scrollView.minimumZoomScale = scaleFactor
    webView.scrollView.maximumZoomScale = scaleFactor
    webView.scrollView.zoomScale = scaleFactor
  }
}

