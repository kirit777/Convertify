//
//  SmoothMinimalGridListView.swift
//  Convertify
//
//  Created by HKinfoway Tech. on 09/01/25.
//
import SwiftUI

class objItem : Hashable{
    var id: UUID = UUID()
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    static func == (lhs: objItem, rhs: objItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct GridListToggleView: View {
    @State var isPresentedDetail: Bool = false
    @State private var isGridView = false
    @State var currentItem:String = ""
    private let items : [objItem]  = [objItem(name: "Length"),objItem(name: "Weight"),objItem(name: "Volume"),objItem(name: "Area"),objItem(name: "Temperature"),objItem(name: "Speed"),objItem(name: "Time"),objItem(name: "Energy"),objItem(name: "Power"),objItem(name: "Angle"),objItem(name: "Pressure"),objItem(name: "Frequency"),objItem(name: "Currency")]

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                VStack {
                    HStack{
                        Text("Minimal")
                        // Grid/List Toggle Button
                        Spacer()
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isGridView.toggle()
                            }
                        }) {
                            Image(systemName: "square.grid.2x2")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding()
                        }
                        
                    }
                    .padding(.horizontal,20)
                    .frame(maxWidth: .infinity, maxHeight:40, alignment: .trailing)

                    // Grid or List View with smooth transitions
                    if isGridView {
                        ScrollView{
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(items, id: \.self) { item in
                                    
                                    itemView(item: item)
                                        .frame(width: (UIScreen.main.bounds.width - 60) / 2 , height:150)
                                        .transition(.scale)
                                        .onTapGesture(perform: {
                                            currentItem = item.name
                                            isPresentedDetail = true
                                        })
                                }
                            }
                            .padding(.horizontal, 20)
                            .transition(.slide)
                        }
                    } else {
                        ScrollView {
                            VStack(spacing: 5) {
                                ForEach(items, id: \.self) { item in
                                    itemViewList(item: item)
                                        .frame(maxWidth: .infinity, minHeight: 70)
                                        .transition(.slide)
                                        .onTapGesture(perform: {
                                            currentItem = item.name
                                            isPresentedDetail = true
                                        })
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    NavigationLink(
                        destination: MainDisplatView(type: currentItem),
                        isActive: $isPresentedDetail,
                        label: {
                            EmptyView() // Invisible view to trigger navigation
                        }
                    )
                    .hidden()
                }
                .background(Color(hex: "#F7F7F7"))
                .navigationBarBackButtonHidden()
                .padding(.bottom, 20)
            }
        }
    }

    @ViewBuilder
    private func itemView(item: objItem) -> some View {
        VStack {
            Image(item.name)
                .resizable()
                .scaledToFit()
                .frame(height: 22)
                .foregroundColor(.blue)
                .padding(.bottom , 5)
            
            Text(item.name)
                .font(.system(size: 14))
                .foregroundColor(.black)
                .padding(.top , 5)
        }
        .frame(width: (UIScreen.main.bounds.width - 60) / 2 , height:150)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 2, y: 2)
    }
    
    @ViewBuilder
    private func itemViewList(item: objItem) -> some View {
        HStack {
            Image(item.name)
                .resizable()
                .scaledToFit()
                .frame(height: 22)
                .foregroundColor(.blue)
                .padding(.leading , 20)
            Text(item.name)
                .font(.system(size: 14))
                .foregroundColor(.black)
            Spacer()
        }
        .frame(height:60)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 2, y: 2)
    }
}


#Preview {
    GridListToggleView()
}
