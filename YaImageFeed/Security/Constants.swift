//
//  Constants.swift
//  YaImageFeed
//
//  Created by Сергей Денисенко on 22.04.2023.
//

import Foundation

final class Constants {
    let AccessKey: String = "mdiyQwfFaXgj71MPg000lIJGuSeT5yylpY-AhT9qNGg"
    let SecretKey: String = "m5EhcUJqHPusWytAw73XhvwV5HzSb8skBzyTDTFzWfs"
    let RedirectURI: String = "urn:ietf:wg:oauth:2.0:oob"
    let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
    let AccessScope: String = "public+read_user+write_likes"
}
