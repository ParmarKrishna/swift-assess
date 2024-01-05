//
//  RequestUserModel.swift
//  swift-assess
//
//  Created by Admin on 05/01/24.
//

import Foundation

struct UserModel:Codable{
    let login:String
    let avatar_url:String
    let followers_url:String
    let following_url:String
    let bio:String
    let updated_at:String
    init(login: String, avatar_url: String, followers_url: String, following_url: String, bio: String, updated_at: String) {
        self.login = login
        self.avatar_url = avatar_url
        self.followers_url = followers_url
        self.following_url = following_url
        self.bio = bio
        self.updated_at = updated_at
    }
}
