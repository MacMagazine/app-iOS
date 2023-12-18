import Foundation
import TipKit

@available(iOS 17, *)
struct SubscriptionsTip: Tip {
	@Parameter
	static var isActive: Bool = true

	var title: Text { Text("Remover propagandas") }
	var message: Text? { Text("Assine para navegar pelo app sem propagandas - ou, alternativamente, use seu login de patrão.") }

	var rules: [Rule] = [
		#Rule(Self.$isActive) { $0 == true }
	]

	var actions: [Action] {
		SideMenuTips.subscriptions.add { tip in
			(tip as? SideMenuTips)?.show()
		}
	}
}

@available(iOS 17, *)
struct PostsTip: Tip {
	@Parameter
	static var isActive: Bool = false

	var title: Text { Text("Posts") }
	var message: Text? { Text("Gerencie a visibilidade dos posts conforme sua preferência.") }

	var rules: [Rule] = [
		#Rule(Self.$isActive) { $0 == true }
	]

	var actions: [Action] {
		SideMenuTips.posts.add { tip in
			(tip as? SideMenuTips)?.show()
		}
	}
}

@available(iOS 17, *)
struct OptionsTip: Tip {
	@Parameter
	static var isActive: Bool = false

	var title: Text { Text("Opções") }
	var message: Text? { Text("Configure o app do seu jeito.") }

	var rules: [Rule] = [
		#Rule(Self.$isActive) { $0 == true }
	]

	var actions: [Action] {
		SideMenuTips.settings.add { tip in
			(tip as? SideMenuTips)?.show()
		}
	}
}

@available(iOS 17, *)
struct AboutTip: Tip {
	@Parameter
	static var isActive: Bool = false

	var title: Text { Text("O app MacMagazine") }
	var message: Text? { Text("Participe da criação do app dando sugestões, reportando problemas ou colaborando com nosso código aberto.") }

	var rules: [Rule] = [
		#Rule(Self.$isActive) { $0 == true }
	]

	var actions: [Action] {
		SideMenuTips.about.add { tip in
			(tip as? SideMenuTips)?.show()
		}
	}
}
