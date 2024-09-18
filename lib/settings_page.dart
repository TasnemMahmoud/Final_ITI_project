import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';
import 'package:share/share.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'settings',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 7.0,
                color: Colors.black38,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.blue), // أيقونة الإشعارات
            title: Text('Enable notifications'),
            trailing: Switch(
              value: settingsProvider.notificationsEnabled,
              onChanged: (bool value) {
                settingsProvider.toggleNotifications(value);
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.dark_mode, color: Colors.blue), // أيقونة الوضع الداكن
            title: Text('Dark mode'),
            trailing: Switch(
              value: settingsProvider.darkTheme,
              onChanged: (bool value) {
                settingsProvider.toggleDarkTheme(value);
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.text_fields, color: Colors.blue), // أيقونة حجم الخط
            title: Text('Font size'),
            subtitle: Slider(
              value: settingsProvider.fontSize,
              min: 10.0,
              max: 24.0,
              divisions: 7,
              label: settingsProvider.fontSize.toString(),
              onChanged: (double value) {
                settingsProvider.setFontSize(value);
              },
            ),
          ),
          Divider(color: Colors.grey),
          ListTile(
            leading: Icon(Icons.share, color: Colors.blue), // أيقونة المشاركة
            title: Text('Share app'),
            onTap: () {
              _shareApp();
            },
          ),
          Divider(color: Colors.grey), // فصل بلون رمادي
          ListTile(
            leading: Icon(Icons.info, color: Colors.blue), // أيقونة معلومات حول التطبيق
            title: Text('About the app'),
            onTap: () {
              // عرض معلومات حول التطبيق
              _showAboutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _shareApp() {
    final String appUrl = 'https://example.com'; // رابط لتحميل التطبيق
    Share.share('Discover the great news app! $appUrl');
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'News App',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2024 Your Company',
      applicationIcon: Icon(Icons.app_blocking, size: 100),
    );
  }
}

