//
//  Константы
//
//  Created by Вадим Мартыненко on 07.02.2024.
//

import Foundation

enum Constants {
    // очередь
    
    static let queue: [QueueItemModel] = [
        .init(id: "QuickDelivery", image: "QuickDelivery", title: "Quick Delivery At Your Doorstep", subtitle: "Enjoy quick pick-up and delivery toyour destination"),
        .init(id: "FlexiblePayment", image: "FlexiblePayment", title: "Flexible Payment", subtitle: "Different modes of payment eitherbefore and after delivery withoutstress"),
        .init(id: "RealTimeTracking", image: "RealTimeTracking", title: "Real-time Tracking", subtitle: "Track your packages/items from the comfort of your home till final destination")
    ]
}
