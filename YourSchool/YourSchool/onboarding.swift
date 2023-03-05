import SwiftUI
import CoreLocation
import CoreLocationUI
import UIKit
import Lottie

struct OnboardingView: View {
	@Binding var isFirstLaunching: Bool
    @State var warnWonsinheung = false
	@State var viewLoaded = false
	var body: some View{
        NavigationView{
            ZStack(alignment: .center){
					VStack{
						Image(systemName: "graduationcap.fill")
							.resizable()
							.frame(width: 200, height: 200)
							.onAppear{
								for family: String in UIFont.familyNames {
									print(family)
									for names : String in UIFont.fontNames(forFamilyName: family){
										print("=== \(names)")
									}
								}
							}
						if viewLoaded{
							Text("Your School")
								.font(.largeTitle)
								.fontWeight(.bold)
								.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5).delay(0.5)))
							
							//					Text("⠼")
							//						.font(.custom("AppleSymbols", size: 36))
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
								
							}
								
							})
							.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5).delay(0.8)))

						}

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
			
			.onAppear {
					withAnimation{
						viewLoaded.toggle()
					}
				
			}
        }
    }
}
struct nameSetupView: View {
	@Binding var isFirstLaunching: Bool
	@State var viewLoaded = false
	@State var secondViewLoaded = false

	@State var ViewSetup = false
	@State var ViewGreeting = false
	@State var tempUserName = ""
    @AppStorage("userName") var userName: String = ""
	@State var enterNameWarning = false
	@State var goNext = false
    var body: some View{
		NavigationView{
			VStack{
				if viewLoaded{
					Text("이름을 입력해주세요.")
						.font(.title)
						.fontWeight(.bold)
					
				}
				if secondViewLoaded{
					HStack{
						TextField("이름을 입력해주세요", text: $tempUserName)
							.padding(.leading, 20)
							.textFieldStyle(.roundedBorder)
						
							.onSubmit {
								if tempUserName.isEmpty {
									enterNameWarning.toggle()
								} else {
									withAnimation{
										viewLoaded.toggle()
										userName = tempUserName
										goNext.toggle()
									}
								}
							}
							.submitLabel(.done)
						if tempUserName.isEmpty {
							Button(action: {
							}, label: {
								Image(systemName: "arrow.forward.square.fill")
									.resizable()
									.frame(width: 35, height: 35)
							})
							.padding(.trailing, 20)
							.disabled(true)
							
							
						} else {
							Button(action: {
								withAnimation{
									viewLoaded.toggle()
									userName = tempUserName
									goNext.toggle()
								}
							}, label: {
								Image(systemName: "arrow.forward.square.fill")
									.resizable()
									.frame(width: 35, height: 35)
									.foregroundColor(.primary)
							})
							.padding(.trailing, 20)
							.disabled(tempUserName.isEmpty)
							
							
						}
						
						
					}
				}
				
				
					
			}
			.onAppear{
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
					withAnimation { viewLoaded.toggle() }
				})
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
					withAnimation { secondViewLoaded.toggle() }
				})
				userName = ""
			}
		}
		.alert(isPresented: $enterNameWarning) {
			Alert(title: Text("이름을 입력해주세요"), message: nil)
		}
		
		.fullScreenCover(isPresented: $goNext) {
			LocationPermissionReqView(isFirstLaunching: $isFirstLaunching, goNext: $goNext)
		}
		
        .navigationBarBackButtonHidden(true)

    }

}
struct LocationPermissionReqView: View {
	@Binding var isFirstLaunching: Bool


	@AppStorage("locationAuth") var locationAuth = false
	@AppStorage("locationDenied") var locationDenied = false
	@AppStorage("locationUndet") var locationUndet = false
	@AppStorage("locationRest") var locationRest = false
	
	@StateObject var locationViewModel = LocationViewModel()
	@State var viewLoaded = false
	@AppStorage("userName") var userName: String = ""
	@State var viewFeatures = false
	@Binding var goNext: Bool
	var body: some View{
		GeometryReader { geo in
			let w = geo.size.width
			let h = geo.size.height
			VStack(alignment: .center) {
				Spacer()
				if viewLoaded{
					Text("👋🏻 안녕하세요, \(userName)님!")
						.font(.title)
						.fontWeight(.bold)
						.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5).delay(1)))
				}
			if locationUndet {
				
					
				//				if locationUndet{
				Text("GPS 사용을 허용해주세요.")
					.font(.title2)
					.fontWeight(.bold)
					.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5).delay(1.3)))
				LottieView(filename: "locationUndet", loopMod: .autoReverse)
					.frame(height: h/8)
					.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5).delay(1.5)))
				
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
				Spacer()
				
				} else if locationAuth {
					
//						Image(systemName: "checkmark.circle.fill")
//							.resizable()
//							.frame(width: 20, height: 20)
//							.foregroundColor(.green)
						LottieView(filename: "success", loopMod: .playOnce)
							.frame(height: h/8)
							.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5).delay(1.5)))
						Text("이제 GPS를 사용할 수 있습니다.")
							.fontWeight(.bold)
							.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5).delay(1.8)))

					
					Spacer()
					Button(action: {
						isFirstLaunching = false
						goNext = false
					}, label: {
						ZStack{
							RoundedRectangle(cornerRadius: 20)
								.fill(.blue)
								.frame(width: 300, height: 70)
							HStack{
								Text("완료")
									.font(.title3)
									.fontWeight(.semibold)
							}.foregroundColor(Color("scheme"))

						}
					})
					.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5).delay(2)))


				} else if locationDenied {
					
						LottieView(filename: "fail", loopMod: .autoReverse)
							.frame(height: h/8)
							.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5).delay(1.5)))
						Text("GPS 사용이 거부되었습니다.")
							.fontWeight(.bold)
							.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5).delay(1.8)))

					
					Text("설정을 완료할 수 있지만 길찾기를 사용할 수 없습니다.")
						.font(.caption2)
						.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5).delay(1.8)))
					Spacer()
					Button(action: {
						isFirstLaunching = false
						goNext = false
					}, label: {
						ZStack{
							RoundedRectangle(cornerRadius: 20)
								.fill(.blue)
								.frame(width: 300, height: 70)
							HStack{
								Text("완료")
									.font(.title3)
									.fontWeight(.semibold)
							}.foregroundColor(Color("scheme"))

						}
					})
					.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5).delay(2)))

				} else if locationRest {
					
						LottieView(filename: "fail", loopMod: .autoReverse)
							.frame(height: h/8)
							.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5).delay(1.5)))
						Text("이 기기에서는 GPS를 사용할 수 없습니다.")
							.fontWeight(.bold)
							.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5).delay(1.8)))
					
					
					Text("설정을 완료할 수 있지만 길찾기를 사용할 수 없습니다.")
						.font(.caption2)
						.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5).delay(1.8)))
					Spacer()
					Button(action: {
						isFirstLaunching = false
						goNext = false
					}, label: {
						ZStack{
							RoundedRectangle(cornerRadius: 20)
								.fill(.blue)
								.frame(width: 300, height: 70)
							HStack{
								Text("완료")
									.font(.title3)
									.fontWeight(.semibold)
							}.foregroundColor(Color("scheme"))

						}
					})
					.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5).delay(2)))

				}
				switch locationViewModel.authorizationStatus {
				case .notDetermined:
					Text("")
						.onAppear{
							print("undet")
							locationUndet = true
						}
					
				case .restricted:
					Text("")
						.onAppear{
							print("rest")
							locationUndet = false
							locationRest = true
							locationAuth = false
						}
				case .denied:
					Text("")
						.onAppear{
							print("deny")
							locationUndet = false
							locationAuth = false
							locationDenied = true
						}
				case .authorizedAlways, .authorizedWhenInUse:
					Text("")
						.onAppear{
							print("auth")
							locationUndet = false
							
							locationAuth = true
							
						}
					
				default:
					ProgressView()
				}
			
			}
		}.onAppear {
			locationAuth = false
			locationDenied = false
			viewLoaded = true
			locationUndet = false
			locationRest = false
//
//			isFirstLaunching = false
//			goNext = false
		}
	}
}
struct FeaturesView: View{
	var body: some View{
		VStack{
			
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
					.onAppear{
						sleep(5)
						print("exit")
					}

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
