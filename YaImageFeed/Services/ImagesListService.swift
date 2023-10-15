//
//  ImagesListService.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 09.10.2023.
//

import Foundation
import ProgressHUD

class ImagesListService {

    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private static let BATCH_SIZE = 10
    static let shared = ImagesListService()
    private let urlSession = URLSession.shared
    private let oauth2Service = OAuth2Service.shared
    private var task: URLSessionTask?
    private var likeTask: URLSessionTask?


    private init() {}

    func fetchPhotosNextPage() {


        let nextPage = 1 + (Int(photos.count) / ImagesListService.BATCH_SIZE)

        assert(Thread.isMainThread)

        if task != nil {
            print("Останавливаю выполнение, потому что запущена задача ImagesListService")
            task?.cancel()
        }
        
        let parameters:[String:String] = [
            "page":String(nextPage),
            "per_page":String(ImagesListService.BATCH_SIZE)
        ]

        let request = URLRequest.makeHTTPRequest(path: "/photos",
                                                 httpMethod: "GET",
                                                 needToken: true,
                                                 parameters: parameters)

        print("ImagesListService: запрашиваю изображения с параметрами: \(parameters)")

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            print("ImagesListService запущена задача")
            DispatchQueue.main.async {

                guard let self = self else { print("ImagesListService тут гард"); return }
                switch result {
                case .success(let body):
                    print("ImagesListService: обновляю фотографии, текущая длина массива фото \(self.photos.count)")
                    self.photos += body.map {
                        Photo(id: $0.id,
                              size: CGSize(width: Double($0.width) ,height: Double($0.height)),
                              createdAt: self.formatDate(dateString: $0.createdAt),
                              welcomeDescription: $0.description,
                              thumbImageURL: $0.urls.thumbLink ?? "",
                              largeImageURL: $0.urls.fullLink ?? "",
                              isLiked: $0.isLiked)
                    }
                    print("ImagesListService: обновил фотографии, текущая длина массива фото \(self.photos.count)")
                    NotificationCenter.default.post(
                        name: ImagesListService.DidChangeNotification,
                        object: self,
                        userInfo: ["photos": self.photos])
                    self.task = nil
                case .failure(let error):
                    print("ImagesListService ОШИБКА \(error)")
                    self.task = nil
                }
            }
        }
        self.task = task
        task.resume()
    }

    func changeLike(photoId: String, isLike: Bool, index: Int, _ completion: @escaping (Result<String, Error>) -> Void) {

        assert(Thread.isMainThread)

        if likeTask != nil {
            print("Останавливаю выполнение, потому что запущена задача ImagesListService")
            likeTask?.cancel()
        }

        let httpMethod = isLike ? "DELETE" : "POST"

        let request = URLRequest.makeHTTPRequest(path: "/photos/\(photoId)/like",
                                                 httpMethod: httpMethod,
                                                 needToken: true)

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikeUpdateResult, Error>) in
            UIBlockingProgressHUD.show()
            print("ImagesListService запущена задача")

            DispatchQueue.main.async {

                guard let self = self else { return }

                switch result {
                case .success(let body):

                    let photoId = body.photo.id
                    self.photos[index].isLiked = !isLike
                    completion(.success(photoId))

                    NotificationCenter.default.post(
                        name: ImagesListService.DidChangeNotification,
                        object: self,
                        userInfo: ["photos": self.photos])
                    self.likeTask = nil

                case .failure(let error):
                    print("ImagesListService ОШИБКА \(error)")
                    self.likeTask = nil
                }
                UIBlockingProgressHUD.dismiss()
            }
        }
        self.task = task
        task.resume()
    }

    private func formatDate(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let date = dateFormatter.date(from: dateString)
        return date
    }
}
