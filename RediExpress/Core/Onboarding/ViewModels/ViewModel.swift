//
//  ViewModel для OnboardingView
//  Содержит всю бизнес логику
//  Created by Вадим Мартыненко on 07.02.2024.
//

import Foundation
import Combine

extension OnboardingView {
    final class ViewModel: ObservableObject {
        // очередь
        @Published private(set) var queue: [QueueItemModel] = []
        
        // элемент очереди, который показывается на экране
        @Published private(set) var currentQueueItem: QueueItemModel? = nil
        
        
        // отвечает за отображение кнопок, если true то отображаются кнопки SKip и Next, если false то отображаются кнопки SignUp и SignIn
        @Published private(set) var showSkipAndNextButton: Bool = true
        
        // содержит полную очередь
        private let fullQueue: [QueueItemModel] = Constants.queue
        
        // содержит publishers
        private var cancellables: Set<AnyCancellable> = .init()
        
        // init
        init(watchedQueueItemId: String?, customQueue: [QueueItemModel]? = nil) {
            addSubcriber()
            
            if let customQueue {
                self.queue = self.createQueue(watchedQueueItemId: watchedQueueItemId, fullQueue: customQueue)
                
                next()
            } else {
                self.queue = self.createQueue(watchedQueueItemId: watchedQueueItemId, fullQueue: fullQueue)
                
                next()
            }
        }
        
        // функция next, берет следующий элемент из очереди
        func next() {
            guard !self.queue.isEmpty else {
                self.currentQueueItem = nil
                return
            }
            
            let element = self.queue.removeFirst()
            self.currentQueueItem = element
            save(id: element.id)
        }
        
        // функция skip, currentQueueItem приравняет к nil, очищает очередь
        func skip() {
            if let last = self.queue.last {
                save(id: last.id)
                self.queue = []
                self.currentQueueItem = nil
            }
        }
        
        // создает очередь
        private func createQueue(watchedQueueItemId: String?, fullQueue: [QueueItemModel]) -> [QueueItemModel] {
            guard let watchedQueueItemId else { return fullQueue }
            
            var queue: [QueueItemModel] = []
            
            var was = false
            
            for item in fullQueue {
                if was {
                    queue.append(item)
                } else {
                    was = item.id == watchedQueueItemId
                }
            }
            
            return queue
        }
        
        // создает подписку на queue
        private func addSubcriber() {
           $queue
                .sink { [weak self] queue in
                    if queue.isEmpty {
                        self?.showSkipAndNextButton = false
                    } else {
                        self?.showSkipAndNextButton = true
                    }
                }
                .store(in: &cancellables)
        }
        
        // сохраняет id в UserDefaults
        private func save(id: String) {
            UserDefaults.standard.setValue(id, forKey: UserDefaultsKeys.watchedQueueItemId)
        }
    }
}
