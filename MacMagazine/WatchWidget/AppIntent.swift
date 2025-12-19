import AppIntents
import WidgetKit

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "MacMagazine" }
    static var description: IntentDescription { "Configuração da complicação." }
}
