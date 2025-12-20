import AppIntents
import WidgetKit

struct AppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "MacMagazine" }
    static var description: IntentDescription { "Configuração da complicação." }
}
