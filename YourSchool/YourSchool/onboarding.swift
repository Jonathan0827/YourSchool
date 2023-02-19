import SwiftUI
import CoreLocation
import CoreLocationUI


struct OnboardingView: View {
	@Binding var isFirstLaunching: Bool
    @State var warnWonsinheung = false
    var body: some View{
        NavigationView{
            ZStack(alignment: .center){
                VStack{
                    Image(systemName: "graduationcap.fill")
                        .resizable()
                        .frame(width: 200, height: 200)
                    Text("Your School")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Button(action: {
                        withAnimation{
                            warnWonsinheung.toggle()
                        }
                    }, label: {ZStack{
                        Capsule()
                            .fill(Color("blackwhite"))
                            .frame(width: 150, height: 60)
                        HStack{
                            Text("시작하기")
                            Image(systemName: "arrow.forward.circle.fill")
                        }.foregroundColor(Color("scheme"))
                        
                    }})
                }
                if warnWonsinheung {
                    //                    GeometryReader { geo in
                    //                        let w = geo.size.width
                    //                        let h = geo.size.height
                    VStack(alignment: .center){
                        Text("시작하기 전에\n확인해주세요")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        NavigationLink(destination: nameSetupView(isFirstLaunching: $isFirstLaunching), label: {
                            ZStack{
                                Capsule()
                                    .fill(Color("blackwhite"))
                                    .frame(width: 300, height: 60)
                                HStack{
                                    Text("원신흥중학교 재학생입니다.")
                                    Image(systemName: "arrow.forward.circle.fill")
                                }.foregroundColor(Color("scheme"))
                                
                            }
                        })
                        NavigationLink(destination: nonWonsinheungView(), label: {
                            ZStack{
                                Capsule()
                                    .fill(Color("blackwhite"))
                                    .frame(width: 305, height: 65)
                                Capsule()
                                    .fill(Color("scheme"))
                                    .frame(width: 300, height: 60)
                                HStack{
                                    Text("원신흥중학교 재학생이 아닙니다.")
                                    Image(systemName: "arrow.forward.circle.fill")
                                }.foregroundColor(.primary)
                                
                            }
                        })
                    }
                    .frame(height: UIScreen.Height/1.5)
                    .padding(20)
                    .background(Color("scheme"))
                    .cornerRadius(30)
					.shadow(color: .primary, radius: 20)
                    .zIndex(10)
                    .transition(.move(edge: .bottom))
                }
                
            }
        }
    }
}
struct nameSetupView: View {
	@Binding var isFirstLaunching: Bool
	@State var ViewSetup = false
	@State var nameOp = 100.0
	@State var ViewGreeting = false
    @AppStorage("userName") var userName: String = ""
	@State var enterNameWarning = false
	@State var goNext = false
    var body: some View{
		NavigationView{
					VStack{
						Text("이름을 입력해주세요.")
							.font(.title)
							.fontWeight(.bold)
						HStack{
							TextField("이름을 입력해주세요", text: $userName)
								.padding(.leading, 20)
								.textFieldStyle(.roundedBorder)
								.onSubmit {
									if userName.isEmpty {
										enterNameWarning.toggle()
									} else {
										withAnimation(.easeIn(duration: 1)){
											nameOp -= 1
										}
										goNext.toggle()
									}
								}
								.submitLabel(.done)
							if userName.isEmpty {
								Button(action: {
									
									goNext.toggle()
								}, label: {
									Image(systemName: "arrow.forward.square.fill")
										.resizable()
										.frame(width: 35, height: 35)
								})
								.padding(.trailing, 20)
								.disabled(true)
							} else {
								Button(action: {
									withAnimation(.easeIn(duration: 4.0)){
										nameOp -= 1
										goNext.toggle()
									}

								}, label: {
									Image(systemName: "arrow.forward.square.fill")
										.resizable()
										.frame(width: 35, height: 35)
										.foregroundColor(.primary)
								})
								.padding(.trailing, 20)
								.disabled(userName.isEmpty)
							}
							
						}
					}

			.alert(isPresented: $enterNameWarning) {
				Alert(title: Text("이름을 입력해주세요"), message: nil)
			}
			.fullScreenCover(isPresented: $goNext) {
				greetingAndFeaturesView(isFirstLaunching: $isFirstLaunching, goNext: $goNext)
			}
        }
        .navigationBarBackButtonHidden(true)

    }

}
struct greetingAndFeaturesView: View {
	@Binding var isFirstLaunching: Bool


	@AppStorage("locationAuth") var locationAuth = false
	@StateObject var locationViewModel = LocationViewModel()
	@State var viewLoaded = false
	@AppStorage("userName") var userName: String = ""
	@Binding var goNext: Bool
	var body: some View{
		VStack{
			if viewLoaded {
					Text("👋🏻 안녕하세요, \(userName)님!")
						.font(.title)
						.fontWeight(.bold)
						.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5).delay(1)))
				if !locationAuth{
					Text("위치 접근을 허용해주세요.")
						.font(.title2)
						.fontWeight(.bold)
					
					Button(action: {
						locationViewModel.requestPermission()
					}, label: {
						ZStack{
							Capsule()
								.fill(Color("blackwhite"))
								.frame(width: 120, height: 40)
							HStack{
								Image(systemName: "location.circle.fill")
								Text("허용하기")
								
							}.foregroundColor(Color("scheme"))
							
						}
					})
					
					.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5).delay(1.7)))
				} else {
					
				}
				switch locationViewModel.authorizationStatus {
				case .notDetermined:
					Text("undet")
					
						.environmentObject(locationViewModel)
				case .restricted:
					Text("rest")
						.onAppear{
							locationAuth = false
						}
				case .denied:
					Text("denied")
						.onAppear{
							locationAuth = false

						}
				case .authorizedAlways, .authorizedWhenInUse:
					Text("authsuc")
						.onAppear{
							locationAuth = true

						}
							.environmentObject(locationViewModel)
						default:
							Text("Unexpected status")
						}

			}
		}.onAppear {
			viewLoaded = true
//			sleep(5)
//
//			isFirstLaunching = false
//			goNext = false
		}
	}
	




}
struct nonWonsinheungView: View{
    var body: some View{
        NavigationView{
            VStack(alignment: .center){
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .foregroundColor(.red)
                    .frame(width: 100, height: 100)
                Text("원신흥중학교 재학생이 아니면\n이 앱을 이용할 수 없습니다")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

            }
        }
        .navigationBarBackButtonHidden(true)

    }
}
//struct OnboardingTabView_Previews: PreviewProvider {
//    @AppStorage("_isFirstLaunching") var first: Bool = true
//
//    static var previews: some View {
//        OnboardingTabView()
//    }
//}
extension UIScreen{
   static let Width = UIScreen.main.bounds.size.width
   static let Height = UIScreen.main.bounds.size.height
   static let Size = UIScreen.main.bounds.size
}
