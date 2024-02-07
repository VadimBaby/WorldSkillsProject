//
//  Экран OnboardingView

//  Created by Вадим Мартыненко on 07.02.2024.
//

import SwiftUI

struct OnboardingView: View {
    
    @StateObject private var viewModel: Self.ViewModel
    
    init(watchedQueueItemId: String?) {
        self._viewModel = StateObject(wrappedValue: .init(watchedQueueItemId: watchedQueueItemId))
    }
    
    var body: some View {
        Group {
            if let currentQueueItem = viewModel.currentQueueItem {
                VStack {
                    Spacer()
                    
                    OnboardingTopView(image: currentQueueItem.image, title: currentQueueItem.title, subtitle: currentQueueItem.subtitle)
                        .transition(.opacity)
                    
                    Spacer()
                    
                    VStack {
                        if viewModel.showSkipAndNextButton {
                            skipAndNextButtons
                        } else {
                            signUpAndSignInButtons
                        }
                    }
                    .frame(height: 82, alignment: .top)
                    .padding(.horizontal, 24)
                    .transition(.opacity)
                }
            } else {
                HolderView()
            }
        }
    }
}

// Расширение для OnboardingView
extension OnboardingView {
    
    // Содержит кнопки Skip и Next
    @ViewBuilder private var skipAndNextButtons: some View {
        HStack {
            Button("Skip") {
                withAnimation(.easeInOut) {
                    viewModel.skip()
                }
            }
            .buttonStyle(SecondaryButtonStyle(width: 100))
            Spacer()
            Button("Next") {
                withAnimation(.easeInOut) {
                    viewModel.next()
                }
            }
            .buttonStyle(PrimaryButtonStyle(width: 100))
        }
    }
    
    // Содержит кнопки SignUp и SignIn
    @ViewBuilder private var signUpAndSignInButtons: some View {
        Button("Sign Up") {
            withAnimation(.easeInOut) {
                viewModel.next()
            }
        }
        .buttonStyle(PrimaryButtonStyle(maxWidth: .infinity))
        Spacer()
        HStack(spacing: 1) {
            Text("Already have an account?")
                .robotoFont(size: 14)
                .foregroundStyle(Color.customSecondaryText)
            Button("Sign In") {
                withAnimation(.easeInOut) {
                    viewModel.next()
                }
            }
            .robotoFont(size: 14)
            .foregroundStyle(Color.customPrimary)
        }
    }
}

#Preview {
    OnboardingView(watchedQueueItemId: nil)
}
