//
//  ProjectArchiveViewController.swift
//  OOTD
//
//  Created by taekki on 2022/09/22.
//

import UIKit

import OOTD_Core
import OOTD_UIKit

final class ProjectArchiveViewController: BaseViewController, ProjectArchiveCollectionViewAdapterDelegate {
    
    private let viewModel = ProjectArchiveViewModel()
    private lazy var adapter: ProjectArchiveCollectionViewAdapter = {
        let adapter = ProjectArchiveCollectionViewAdapter(collectionView: rootView.collectionView, adapterDataSource: viewModel, delegate: self)
        return adapter
    }()
    
    private let rootView = ProjectArchiveView()
    
    override func loadView() {
        self.view = rootView
    }
    
    override func bind() {
        adapter.adapterDataSource = viewModel
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct Preview: PreviewProvider {
    static var previews: some View {
        ProjectArchiveViewController().showPreview(.iPhone13Mini)
    }
}
#endif
