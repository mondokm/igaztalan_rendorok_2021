//
//  DependencyInjector.swift
//  ITSecurityHW
//
//  Created by Kristof Kalai on 2021. 11. 01..
//

import Swinject

public struct DependencyInjector {
    private static let container = Container()
}

extension DependencyInjector {
    public static func registerDependencies() {
        registerCaches()
        registerServices()
    }

    public static func resolve<Service>(_ serviceType: Service.Type) -> Service {
        container.resolve(serviceType)!
    }
}

extension DependencyInjector {
    private static func registerCaches() {
        container.register(ImageCache.self) { _ in
            ImageCache()
        }
        .inObjectScope(.container)
        container.register(ImageDetailCache.self) { _ in
            ImageDetailCache()
        }
        .inObjectScope(.container)
        container.register(FullImageCache.self) { _ in
            FullImageCache()
        }
        .inObjectScope(.container)
        container.register(SearchCache.self) { _ in
            SearchCache()
        }
        .inObjectScope(.container)
        container.register(UserCache.self) { _ in
            UserCache()
        }
        .inObjectScope(.container)
        container.register(TokenCache.self) { _ in
            TokenCache()
        }
        .inObjectScope(.container)
    }

    private static func registerServices() {
        let imageService = ImageService()
        container.register(ImageActionProtocol.self) { _ in
            imageService
        }
        container.register(ImageStoreProtocol.self) { _ in
            imageService
        }

        let imageDetailService = ImageDetailService()
        container.register(ImageDetailActionProtocol.self) { _ in
            imageDetailService
        }
        container.register(ImageDetailStoreProtocol.self) { _ in
            imageDetailService
        }

        let searchService = SearchService()
        container.register(SearchActionProtocol.self) { _ in
            searchService
        }
        container.register(SearchStoreProtocol.self) { _ in
            searchService
        }

        let userService = UserService()
        container.register(UserActionProtocol.self) { _ in
            userService
        }
        container.register(UserStoreProtocol.self) { _ in
            userService
        }
    }
}
