//
//  DSErrorView.swift
//  Dior Retail App
//
//  Created by Itay Gervash on 20/01/2023.
//  Copyright © 2023 Balink. All rights reserved.
//

import SwiftUI

struct ErrorView: View {

    @Binding var error: Error?

    var onRetry: (() -> Void)? = nil

    var body: some View {
        ZStack {
            Color.black.opacity(0.25)
                .ignoresSafeArea(.all)
                .onTapGesture { dismiss() }
            
            alertBody()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.background)
                )
                .padding(.horizontal, 36)
        }
        .onAppear {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }

    //MARK: - ViewBuilder Methods

    @ViewBuilder
    func alertBody() -> some View {
        VStack {

            Image(systemName: "exclamationmark.circle")
                .resizable()
                .scaledToFit()
                .frame(height: 36)
                .padding(.top, 24)
                .padding(.bottom, 12)
                .foregroundColor(.red)

            if let error {
                Text((error).localizedDescription)
                    .font(.system(size: 20))
                    .padding(.horizontal, 36)
                    .multilineTextAlignment(.center)
            }
            
            buttonStack()
                .padding(.horizontal, 56)
                .padding(.vertical, 24)
        }
    }

    @ViewBuilder
    func buttonStack() -> some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Text("OK")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.label)
            }

            if let onRetry = onRetry {
                Spacer()

                Button {
                    dismiss()
                    onRetry()
                } label: {
                    Text("Retry")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.label)
                }
            }

        }
    }

    //MARK: - Helper Methods

    private func dismiss() {
        error = nil
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: .constant(NSError(domain: "An Unknown Error Has Occured", code: 999)))
    }
}
