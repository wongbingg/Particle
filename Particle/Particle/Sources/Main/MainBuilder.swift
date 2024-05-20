//
//  MainBuilder.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs

protocol MainDependency: Dependency {
    
}

final class MainComponent: Component<MainDependency> {
    var recordRepository: RecordRepository
    var userRepository: UserRepository
    var searchRepository: SearchRepository
    var authService: AuthService
    
    var fetchRecordByIdUseCase: FetchRecordByIdUseCase {
        return DefaultFetchRecordByIdUseCase(recordRepository: recordRepository)
    }
    
    init(
        dependency: MainDependency,
        recordRepository: RecordRepository,
        userRepository: UserRepository,
        searchRepository: SearchRepository,
        authService: AuthService
    ) {
        self.recordRepository = recordRepository
        self.userRepository = userRepository
        self.searchRepository = searchRepository
        self.authService = authService
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol MainBuildable: Buildable {
    func build(withListener listener: MainListener) -> MainRouting
}

final class MainBuilder: Builder<MainDependency>, MainBuildable {
    
    private var accessToken: String {
        guard let token = UserDefaults.standard.string(forKey: "ACCESSTOKEN") else {
            Console.error("AccessToken 이 존재하지 않습니다.")
            return ""
        }
        return token
    }
    
    private lazy var apiDataTransferService: DataTransferService = {
        
        let configuration = ApiDataNetworkConfig(
            baseURL: URL(string: ParticleServer.baseURL)!,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
        )
        let networkService = DefaultNetworkService(config: configuration)
        return DefaultDataTransferService(with: networkService)
    }()
    
    override init(dependency: MainDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: MainListener) -> MainRouting {
        
        
//        let recordDataSource = DefaultRecordDataSource(dataTransferService: apiDataTransferService)
        let recordDataSource = LocalRecordDataSource(coreData: .shared) // coreData로 데이터소스 변경
        let recordRepository = DefaultRecordRepository(recordDataSource: recordDataSource, recordMapper: RecordMapper())
        
        let userDataSource = DefaultUserDataSource(dataTransferService: apiDataTransferService)
        let userRepository = DefaultUserRepository(userDataSource: userDataSource)
        
        let searchDataSource = DefaultSearchDataSource(dataTransferService: apiDataTransferService)
        let searchRepository = DefaultSearchRepository(searchDataSource: searchDataSource)
        
        let authService = DefaultAuthService(dataTransferService: apiDataTransferService)
        
        let component = MainComponent(
            dependency: dependency,
            recordRepository: recordRepository,
            userRepository: userRepository, 
            searchRepository: searchRepository,
            authService: authService
        )
        let viewController = MainTabBarController()
        let interactor = MainInteractor(
            presenter: viewController,
            fetchRecordByIdUseCase: component.fetchRecordByIdUseCase
        )
        interactor.listener = listener
        
        let home = HomeBuilder(dependency: component)
//        let explore = ExploreBuilder(dependency: component)
//        let search = SearchBuilder(dependency: component)
        let mypage = MyPageBuilder(dependency: component)
        let recordDetail = RecordDetailBuilder(dependency: component)
        
        return MainRouter(
            interactor: interactor,
            viewController: viewController,
            home: home,
//            explore: explore,
//            search: search,
            mypage: mypage, 
            recordDetail: recordDetail
        )
    }
}

extension MainComponent: HomeDependency,
                         ExploreDependency,
                         SearchDependency,
                         MyPageDependency,
                         RecordDetailDependency {}
