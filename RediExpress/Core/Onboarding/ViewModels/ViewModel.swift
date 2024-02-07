//
//  ViewModel для OnboardingView
//  Содержит всю бизнес логику
//  Created by Вадим Мартыненко on 07.02.2024.
//

import Foundation

extension OnboardingView {
    final class ViewModel: ObservableObject {
        // очередь
        @Published private(set) var queue: [QueueItemModel] = []
        
        // элемент очереди, который показывается на экране
        @Published private(set) var currentQueueItem: QueueItemModel? = Constants.queue.last
        
        
        // отвечает за отображение кнопок, если true то отображаются кнопки SKip и Next, если false то отображаются кнопки SignUp и SignIn
        @Published private(set) var showSkipAndNextButton: Bool = true
        
        // init
        init(watchedQueueItemId: String?, customQueue: [QueueItemModel]? = nil) {
            if let customQueue {
                self.queue = customQueue
            }
        }
        
        // функция next, берет следующий элемент из очереди
        func next() {
            
        }
        
        // функция skip, currentQueueItem приравняет к nil, очищает очередь
        func skip() {
            
        }
    }
}
