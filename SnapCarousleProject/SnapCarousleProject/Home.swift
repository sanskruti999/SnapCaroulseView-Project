//
//  Home.swift
//  SnapCarousleProject
//
//  Created by Siddhatech on 10/08/24.
//

import SwiftUI

var AppGradient = LinearGradient(colors: [Color(UIColor(red: 0.004, green: 0.129, blue: 0.412, alpha: 1)),
                                                    Color(UIColor(red: 0.033, green: 0.2, blue: 0.465, alpha: 0.92)),
                                                    Color(UIColor(red: 0.118, green: 0.408, blue: 0.62, alpha: 0.87)),
                                          Color(UIColor(red: 0.116, green: 0.406, blue: 0.50, alpha: 0.50)),
                                          Color(UIColor(red: 0.110, green: 0.403, blue: 0.30, alpha: 0.30)),
                                                    Color(UIColor(red: 1, green: 1, blue: 1, alpha: 0.59)),
                                                    Color(UIColor(red: 1, green: 1, blue: 1, alpha: 0.59)),
                                                    Color(UIColor(red: 1, green: 1, blue: 1, alpha: 0.59))], startPoint: .top, endPoint: .bottom)
struct Post : Identifiable{
    var id = UUID()
    var postImage : String
}
struct SnapCarousel<Content: View, T: Identifiable>: View {
    var content: (T) -> Content
    var list: [T]
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    
    init(spacing: CGFloat = 15, trailingSpace: CGFloat = 70, index: Binding<Int>, items: [T], @ViewBuilder content: @escaping (T)->Content){
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }
    @GestureState var offset : CGFloat = 0
    @State var currentIndex: Int = 0
    var body: some View{
        GeometryReader{ proxy in
            let width = proxy.size.width - (trailingSpace - spacing)
            let adjustMenWidth = (trailingSpace / 2) - spacing
            HStack(spacing:spacing){
                ForEach(list){ item in
                    content(item)
                        .frame(width: currentIndex != 0 ? proxy.size.width - trailingSpace + 5 : proxy.size.width - trailingSpace + 15)
                        .padding(.trailing, currentIndex != 0 ? -9 : 0)
                        .padding(.leading, currentIndex != 0 ? 12 : 0)
                }
            }.padding(.horizontal,currentIndex != 0 ? spacing + 12 : spacing + 8)
                .offset(x: (CGFloat(currentIndex) * -(width + spacing)) + offset)
                .gesture(
                    DragGesture()
                        .updating($offset, body: {
                            value, out, _
                            in
                            out = value.translation.width
                        })
                        .onEnded({ value in
                            let offsetX = value.translation.width
                            let progress = -offsetX / width
                            let roundIndex = progress.rounded()
                            currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1),0)
                            index = currentIndex
                        })
                )
        }.animation(.easeInOut,value: offset == 0)
    }
}
struct Home: View {
    @State var currentIndex: Int = 0
    @State var posts: [Post] = []
    @State var flowers: [String] = ["Fortune Oil", "Sprouts", "Spieces", "Noodles"]
    @State var fruits: [String] = ["Apple", "Banana", "Orange","Waterlemon"]
    @State var dairyProduct: [String] = ["Milk", "Paneer", "Butter","Curd"]
    @State var searchQuery: String = ""
    var body: some View {
        ZStack {
            AppGradient.ignoresSafeArea()
            VStack{
                Text("All In One").foregroundColor(Color.white).fontWeight(.bold) .italic().font(.system(size: 24))
                Divider().background(Color.white).padding(.vertical,10)
                GeometryReader{ reader in
                    ScrollView(showsIndicators: false){
                        Text((currentIndex == 0 ? "Grocery Product" : (currentIndex == 1 ? "Fruits And Vegetable" : "Dairy Products"))).padding(.vertical,10).foregroundColor(Color.white)
                        VStack{
                            SnapCarousel(index: $currentIndex, items: posts) { post in
                                GeometryReader { proxy in
                                    let size = proxy.size
                                    CustomDetailCardView {
                                        Image(post.postImage)
                                            .resizable()
                                            .frame(width: 300, height: 300)
                                    }
                                }
                                
                            }.padding(.bottom,30)
                            HStack(spacing: 10) {
                                ForEach(Array(posts.enumerated()), id: \.1.id) { index, post in
                                    Circle()
                                        .fill(Color.black.opacity(currentIndex == index ? 1 : 0.1))
                                        .frame(width: 10, height: 10)
                                        .scaleEffect(currentIndex == index ? 1.4 : 1)
                                        .animation(.spring(), value: currentIndex == index)
                                }
                            }.padding(.vertical,10).padding(.top,30)
                            VStack{
                                SearchBar(text: $searchQuery).padding(.bottom,15)
                                VStack{
                                    if let results = searchedItems(currentIndex == 0 ? flowers : (currentIndex == 1 ? fruits : dairyProduct))  {
                                        ForEach(Array(results.enumerated()), id: \.offset) { index, item in
                                            HStack(spacing:20){
                                                Image(item)
                                                    .resizable()
                                                    .frame(width: 50, height: 40)
                                                Text(item)
                                            }.frame(maxWidth:.infinity,maxHeight:60,alignment:.leading).padding(.horizontal,8)
                                                if index != results.count - 1 {
                                                    Divider().padding(.horizontal,-20)
                                                }
                                            //.background(index % 2 != 0 ? Color.orange : Color.white)
                                        }
                                    } else {
                                        VStack{
                                            Image("NoResult").resizable()
                                                .frame(width: 100,height: 100)
                                            Text("No results found")
                                                .foregroundColor(.gray)
                                                .padding(.vertical, 20)
                                            
                                        }.listRowSeparator(.hidden).frame(maxWidth: .infinity,alignment:.center).padding(.top,40)
                                    }
                                }.frame(maxWidth: .infinity,maxHeight:.infinity,alignment:.leading)//.padding(.top,-40)
                            }.padding(.horizontal,24)
                            
                        }.frame(width:reader.size.width,height: reader.size.height)//.padding(.top,50)
                    }.padding(.top,-8)
                }
            }
            .onAppear {
                for index in 1...3 {
                    var post = Post(postImage: "post\(index)")
                    posts.append(post)
                }
            }
        }
    }
    func searchedItems(_ items: [String]) -> [String]?{
            if searchQuery.isEmpty {
                return items
            } else {
                let results = items.filter { $0.lowercased().contains(searchQuery.lowercased()) }
                return results.isEmpty ? nil : results
            }
        }
}
struct CustomDetailCardView<Content: View>: View {
    let content : ()-> Content

    var body: some View {
        VStack{
            content()
        }.padding().padding(.top,10).overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .background(
            RoundedRectangle(
                cornerRadius: 12
            )
            .foregroundColor(Color.white)
            .shadow(
                color: Color.gray.opacity(0.5),
                radius: 5,
                x: 0,
                y: 1
            )
        )

    }
}
struct SearchBar: View {
    @Binding var text: String
    @FocusState private var isEditing: Bool

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search", text: $text)
                .foregroundColor(.primary)
                .focused($isEditing)
            Spacer()
            Image(systemName: "Cross") .foregroundColor(.gray)
                .onTapGesture {
                    text = ""
                }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(isEditing ? Color.orange.opacity(0.1) : Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isEditing ? Color.orange : Color.gray, lineWidth: 1)
        )
    }
}
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
