//
//  Экран Holder
//  Created by Вадим Мартыненко on 07.02.2024.
//

import SwiftUI

struct HolderView: View {
    var body: some View {
        NavigationStack {
            Text("Holder")
                .onTapGesture {
                    UserDefaults.standard.setValue(nil, forKey: UserDefaultsKeys.watchedQueueItemId)
                }
        }
    }
}

#Preview {
    HolderView()
}
