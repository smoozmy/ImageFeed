//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Александр Крапивин on 18.08.2024.
//

import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?

    var loadRequestCalled: Bool = false

    func load(request: URLRequest) {
        loadRequestCalled = true
    }

    func setProgressValue(_ newValue: Float) { }

    func setProgressHidden(_ isHidden: Bool) { }
}
