[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom, ContentType = WindowsRuntime] > $null
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null

$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
$xml.LoadXml([Console]::In.ReadToEnd())

$toast = [Windows.UI.Notifications.ToastNotification]::new($xml)

$app = Get-StartApps -Name "Windows Powershell" | Select-Object -Index 0

$notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($app.AppID)
$notifier.Show($toast);
