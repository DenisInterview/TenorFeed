//
//  VideoModel.swift
//  TubiTest
//
//  Created by Denis Kalashnikov on 2/16/19.
//  Copyright © 2019 Denis Kalashnikov. All rights reserved.
//

import Foundation
import Alamofire

class VideoTenorModel: Codable {
    let weburl: String?
    let results: [VideoModel]?
    let next: String?
    
    init(weburl: String?, results: [VideoModel]?, next: String?) {
        self.weburl = weburl
        self.results = results
        self.next = next
    }
}

class VideoModel: Codable {
    let tags: [String]?
    let url: String?
    let media: [[String: Media]]?
    let created: Double?
    let shares: Int?
    let itemurl: String?
    let hasaudio: Bool?
    let title, id: String?
    let hascaption: Bool?
    
    init(tags: [String]?, url: String?, media: [[String: Media]]?, created: Double?, shares: Int?, itemurl: String?, hasaudio: Bool?, title: String?, id: String?, hascaption: Bool?) {
        self.tags = tags
        self.url = url
        self.media = media
        self.created = created
        self.shares = shares
        self.itemurl = itemurl
        self.hasaudio = hasaudio
        self.title = title
        self.id = id
        self.hascaption = hascaption
    }
}

class Media: Codable {
    let url: String?
    let dims: [Int]?
    let preview: String?
    let size: Int?
    let duration: Double?
    
    init(url: String?, dims: [Int]?, preview: String?, size: Int?, duration: Double?) {
        self.url = url
        self.dims = dims
        self.preview = preview
        self.size = size
        self.duration = duration
    }
}

fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, tvOS 10.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

fileprivate func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, tvOS 10.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - Alamofire response handlers

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try newJSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseVideoModel(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<VideoTenorModel>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
