//
//  HeaderPageScrollView.swift
//  IOS18-SwiftUI
//
//  Created by xqsadness on 19/5/25.
//

import SwiftUI

struct PageLabel {
    var title: String
    var symbolImage: String
}

@resultBuilder
struct PageLabelBuilder {
    static func buildBlock(_ components: PageLabel...) -> [PageLabel] {
        components.compactMap { $0 }
    }
}

struct HeaderPageScrollView<Header: View, Pages: View>: View {
    var displaysSymbols: Bool = false
    /// Header View
    var header: Header
    /// Labels (Tab Title or Tab Image)
    var labels: [PageLabel]
    /// Tab Views
    var pages: Pages
    //For refereshing
    var onRefresh: () async -> ()
    
    init(
        displaysSymbols: Bool,
        @ViewBuilder header: @escaping () -> Header,
        @PageLabelBuilder labels:  @escaping () -> [PageLabel],
        @ViewBuilder pages:  @escaping () -> Pages,
        onRefresh: @escaping () async -> () = { }
    ) {
        self.displaysSymbols = displaysSymbols
        self.header = header()
        self.labels = labels()
        self.pages = pages()
        self.onRefresh = onRefresh
        
        let count = labels().count
        self._scrollPositions = .init(initialValue: .init(repeating: .init(), count: count))
        self._scrollGeometries = .init(initialValue: .init(repeating: .init(), count: count))
    }
    
    ///View props
    @State private var activeTab: String?
    @State private var headerHeight: CGFloat = 0
    @State private var scrollGeometries: [ScrollGeometry]
    @State private var scrollPositions: [ScrollPosition]
    ///Main Scroll Props
    @State private var mainScrollDisabled: Bool = false
    @State private var mainScrollPhase: ScrollPhase = .idle
    @State private var mainScrollGeometry: ScrollGeometry = .init()
    var body: some View {
        GeometryReader {
            let size = $0.size

            ScrollView(.horizontal) {
                /// Using HStack allows us to maintain references to other scrollviews, enabling us to update them when necessary.
                HStack(spacing: 0) {
                    Group(subviews: pages) { collection in
                        /// Checking both collection and labels match with each other
                        if collection.count != labels.count {
                            Text("Tabviews and labels does not match!")
                                .frame(width: size.width, height: size.height)
                        } else {
                            ForEach(labels, id: \.title){ label in
                                PageScrollView(label: label, size: size, collection: collection)
                            }
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $activeTab)
            .scrollIndicators(.hidden)
            .scrollDisabled(mainScrollDisabled)
            /// Disabling interaction when scroll view is animating to avoid unintentional taps!
            .allowsHitTesting(mainScrollPhase == .idle)
            .onScrollPhaseChange({ oldPhase, newPhase in
                mainScrollPhase = newPhase
            })
            .onScrollGeometryChange(for: ScrollGeometry.self, of: {
                $0
            }, action: { oldValue, newValue in
                mainScrollGeometry = newValue
            })
            .mask{
                Rectangle()
                    .ignoresSafeArea(.all, edges: .bottom)
            }
            .onAppear{
                //Setting up init tab value
                guard activeTab == nil else { return }
                
                activeTab = labels.first?.title
            }
        }
    }
    
    @ViewBuilder
    func PageScrollView(label: PageLabel, size: CGSize, collection: SubviewsCollection) -> some View {
        let index = labels.firstIndex(where: { $0.title == label.title }) ?? 0

        ScrollView(.vertical) {
            /// Using LazyVStack for Optimizing Performance as it LazyLoads Views!
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                /// Only Showing Header for the active Tab View!
                ZStack {
                    if activeTab == label.title {
                        header
                        /// Making it as a sticky one so that it won't move left or right when interacting!
                            .visualEffect { content, proxy in
                                content
                                    .offset(x: -proxy.frame(in: .scrollView(axis: .horizontal)).minX)
                            }
                            .onGeometryChange(for: CGFloat.self) {
                                $0.size.height
                            } action: { newValue in
                                headerHeight = newValue
                            }
                            .transition(.identity)
                    } else {
                        Rectangle()
                            .foregroundStyle(.clear)
                            .frame(height: headerHeight)
                            .transition(.identity)
                    }
                }
                .simultaneousGesture(horizontalScrollDisableGesture)
                
                /// Using Pinned Views to actually pin our tab bar at the top!
                Section {
                    collection[index]
                        .frame(minHeight: size.height - 40, alignment: .top)
                } header: {
                    /// Doing the same behaviour as the header view!
                    ZStack {
                        if activeTab == label.title {
                            CustomTabBar()
                                .visualEffect { content, proxy in
                                    content
                                        .offset(x: -proxy.frame(in: .scrollView(axis: .horizontal)).minX)
                                }
                                .transition(.identity)
                        } else {
                            Rectangle()
                                .foregroundStyle(.clear)
                                .frame(height: 40)
                                .transition(.identity)
                        }
                    }
                    .simultaneousGesture(horizontalScrollDisableGesture)
                }
            }
        }
        .onScrollGeometryChange(
            for: ScrollGeometry.self,
            of: {
                $0
            },
            action: { oldValue, newValue in
                scrollGeometries[index] = newValue
                
                if newValue.offsetY < 0 {
                    resetScrollViews(label)
                }
            })
        .scrollPosition($scrollPositions[index])
        .onScrollPhaseChange({ oldPhase, newPhase in
            let geometry = scrollGeometries[index]
            let maxOffset = min(geometry.offsetY, headerHeight)

            if newPhase == .idle && maxOffset <= headerHeight {
                updateOtherScrollViews(label, to: maxOffset)
            }
            
            //Fail-safe
            if newPhase == .idle && mainScrollDisabled{
                mainScrollDisabled = false
            }
        })
        .frame(width: size.width)
        .scrollClipDisabled()
        .zIndex(activeTab == label.title ? 1000 : 0)
        .refreshable {
            await onRefresh()
        }
    }
    
    /// Custom Tab Bar
    @ViewBuilder
    func CustomTabBar() -> some View {
        let progress = mainScrollGeometry.offsetX / mainScrollGeometry.containerSize.width
        
        VStack(alignment: .leading, spacing: 5){
            HStack(spacing: 0) {
                ForEach(labels, id: \.title) { label in
                    Group {
                        if displaysSymbols {
                            Image(systemName: label.symbolImage)
                        } else {
                            Text(label.title)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(activeTab == label.title ? Color.primary : .gray)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            activeTab = label.title
                        }
                    }
                }
            }
            
            /// Let's Create a sliding indicator for the tab bar!
            Capsule()
                .frame(width: 50, height: 4)
                .containerRelativeFrame(.horizontal) { value, _ in
                    return value / CGFloat(labels.count)
                }
                .visualEffect{ content, proxy in
                    content
                        .offset(x: proxy.size.width * progress)
                }
        }
        .frame(height: 40)
        .background(.background)
    }
    
    var horizontalScrollDisableGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                mainScrollDisabled = true
            }
            .onEnded { _ in
                mainScrollDisabled = false
            }
    }
    
    /// Reset's Page ScrollView to it's Initial Position
    func resetScrollViews(_ from: PageLabel) {
        for index in labels.indices {
            let label = labels[index]

            if label.title != from.title {
                scrollPositions[index].scrollTo(y: 0)
            }
        }
    }
    
    /// Update Other scrollviews to match up with the current scroll view till reaching its header height
    func updateOtherScrollViews(_ from: PageLabel, to: CGFloat) {
        for index in labels.indices {
            let label = labels[index]
            let offset = scrollGeometries[index].offsetY

            let wantsUpdate = offset < headerHeight || to < headerHeight

            if wantsUpdate && label.title != from.title {
                scrollPositions[index].scrollTo(y: to)
            }
        }
    }
}

#Preview {
    InstagramProfileScrollView()
}

extension ScrollGeometry {
    init() {
        self.init(contentOffset: .zero, contentSize: .zero, contentInsets: .init(.zero), containerSize: .zero)
    }

    var offsetX: CGFloat {
        contentOffset.x + contentInsets.leading
    }
}
