import 'package:authentication_sample_with_supabase_flutter/models/google_sign_in_options.dart';

List<GoogleSignInOptions> getPartOfOptions() {
  final taskAPI = GoogleSignInOptions(
    'Google Tasks API、v1',
    [
      GoogleSignInOption(
        'https://www.googleapis.com/auth/tasks',
        'すべてのタスクを作成、編集、管理、削除できます',
      ),
      GoogleSignInOption(
        'https://www.googleapis.com/auth/tasks.readonly',
        'タスクを表示',
      ),
    ],
  );

  final calendarApi = GoogleSignInOptions(
    'Calendar API、v3',
    [
      GoogleSignInOption(
        'https://www.googleapis.com/auth/calendar',
        'Googleカレンダーを使用してアクセスできるすべてのカレンダーを表示、編集、共有、完全に削除する',
      ),
      GoogleSignInOption(
        'https://www.googleapis.com/auth/calendar.events',
        'すべてのカレンダーのイベントを表示および編集します',
      ),
      GoogleSignInOption(
        'https://www.googleapis.com/auth/calendar.events.readonly',
        'すべてのカレンダーでイベントを表示する',
      ),
      GoogleSignInOption(
        'https://www.googleapis.com/auth/calendar.readonly',
        'Googleカレンダーを使用してアクセスできるカレンダーを表示してダウンロードします',
      ),
      GoogleSignInOption(
        'https://www.googleapis.com/auth/calendar.settings.readonly',
        'カレンダーの設定を表示する',
      ),
    ],
  );

  final gmailApi = GoogleSignInOptions(
    'Gmail API、v1',
    [
      GoogleSignInOption(
        'https://mail.google.com/',
        'Gmail のメールを閲覧、作成したり、Gmail からすべてのメールを完全に削除したりできます',
      ),
      GoogleSignInOption(
        'https://www.googleapis.com/auth/gmail.addons.current.action.compose',
        'アドオン操作時の下書きの管理とメールの送信',
      ),
      GoogleSignInOption(
        'https://www.googleapis.com/auth/gmail.addons.current.message.action',
        'アドオンの操作時にメール メッセージを表示',
      ),
      GoogleSignInOption(
        'https://www.googleapis.com/auth/gmail.addons.current.message.metadata',
        'アドオンの実行時にメール メッセージのメタデータを表示',
      ),
      GoogleSignInOption(
        'https://www.googleapis.com/auth/gmail.addons.current.message.readonly',
        'アドオンの実行時にメール メッセージを表示',
      ),
      GoogleSignInOption(
        'https://www.googleapis.com/auth/gmail.compose',
        '下書きの管理とメールの送信',
      ),
      GoogleSignInOption(
        'https://www.googleapis.com/auth/gmail.insert',
        'Gmail のメールボックスにメールを追加します',
      ),
      GoogleSignInOption(
        'https://www.googleapis.com/auth/gmail.labels',
        'メールラベルを表示、編集する',
      ),
      GoogleSignInOption(
        'https://www.googleapis.com/auth/gmail.metadata',
        'ラベルやヘッダーなど、メール メッセージのメタデータは表示されますが、メール本文は表示されません',
      ),
      GoogleSignInOption(
        'https://www.googleapis.com/auth/gmail.modify',
        'Gmail アカウントのメールを閲覧、作成、送信します',
      ),
      GoogleSignInOption(
        'https://www.googleapis.com/auth/gmail.readonly',
        'メール メッセージと設定の表示',
      ),
      GoogleSignInOption(
        'https://www.googleapis.com/auth/gmail.send',
        'ユーザーに代わるメールの送信',
      ),
      GoogleSignInOption(
        'https://www.googleapis.com/auth/gmail.settings.basic',
        'Gmail のメール設定とフィルタを表示、編集、作成、変更します',
      ),
      GoogleSignInOption(
        'https://www.googleapis.com/auth/gmail.settings.sharing',
        '機密メールの設定（例: メールを管理できるユーザー）の管理',
      ),
    ],
  );

  return [
    taskAPI,
    calendarApi,
    gmailApi,
  ];
}
