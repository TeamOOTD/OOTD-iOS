//
//  ProjectArchiveSection.swift
//  OOTD
//
//  Created by taekki on 2022/09/22.
//

import UIKit

import OOTD_UIKit

enum ProjectArchiveSection: String, CaseIterable {
    case logo       = "로고"
    case name       = "프로젝트 명"
    case desc       = "한 줄 소개"
    case gitHubLink = "깃허브 링크"
    case member     = "팀원"
    case period     = "프로젝트 기간"
    case tech       = "사용 기술 및 라이브러리"
    case memo       = "메모"
}

extension ProjectArchiveSection {

    var itemSize: NSCollectionLayoutSize {
        switch self {
        case .memo:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(175)
            )
        case .member, .tech:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(48)
            )
        default:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        }
    }
    
    var groupSize: NSCollectionLayoutSize {
        switch self {
        case .logo:
            return NSCollectionLayoutSize(
                widthDimension: .estimated(64),
                heightDimension: .estimated(64)
            )
        case .name, .desc, .gitHubLink, .period:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(44)
            )
        case .member, .tech:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(48)
            )
        case .memo:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(175)
            )
        }
    }
    
    var groupInsets: NSDirectionalEdgeInsets {
        return .zero
    }
    
    var sectionInsets: NSDirectionalEdgeInsets {  
        return NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
    }
    
    var isNecessary: Bool {
        switch self {
        case .logo, .name, .desc, .period, .tech:
            return true
        default:
            return false
        }
    }
}

extension ProjectArchiveSection {
    
    var placeholder: String? {
        switch self {
        case .name:
            return "프로젝트 명을 적어주세요."
        case .desc:
            return "프로젝트 한 줄 소개를 적어주세요."
        case .gitHubLink:
            return "프로젝트의 깃허브 주소를 적어주세요."
        case .member:
            return "함께한 팀원이 있다면 팀원을 적어주세요."
        case .tech:
            return "사용한 기술 또는 라이브러리를 적어주세요."
        case .memo:
            return """
            담당 기능, 역할, 깨달은 점 등을 자유롭게 적어주세요.
            
            담당 기능 및 역할
            - 투두 작성
            - 투두 수정
            - 투두 삭제
            
            학습 내용
            - Realm을 이용한 로컬 DB 설계 및 활용
            """
        default:
            return nil
        }
    }
}
