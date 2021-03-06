param(
    [String] $AppID,
    [String] $Name
)

[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom, ContentType = WindowsRuntime] > $null
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null

[Console]::InputEncoding = [System.Text.Encoding]::UTF8

$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
$xml.LoadXml([Console]::In.ReadToEnd())

$toast = [Windows.UI.Notifications.ToastNotification]::new($xml)

if ($AppID.Length -eq 0) {
    if ($Name.Length -eq 0) {
        $Name = "Emacs"
    }
    $app = Get-StartApps -Name $Name | Select-Object -Index 0
    if ($app -eq $null) {
        $AppID = "Emacs"
    } else {
        $AppID = $app.AppID
    }
}

$notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppID)
$notifier.Show($toast);
