//
//  UserChatModel.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 02.03.2024.
//

import Foundation

struct UserChatModel: Codable {
    let user: UserInfoModel
    let message: MessageModel?
}
