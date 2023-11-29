//
//  OnboardingView.swift
//  MVVMc
//
//  Created by Никитин Артем on 23.10.23.
//

import SwiftUI

struct OnboardingView: View {
    var doneRequested: () -> Void

    var body: some View {
        TabView {
            ScaledImageView(name: "burger1")
                .tag(0)
            ScaledImageView(name: "burger2")
                .tag(1)
            ScaledImageView(name: "burger3")
                .tag(2)

            Button("Done") {
                doneRequested()
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .background(Color.black.ignoresSafeArea(.all))
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(doneRequested: { })
    }
}

struct ScaledImageView: View {
    let name: String
    var body: some View {
        Image(name)
            .resizable()
            .scaledToFit()
    }
}
