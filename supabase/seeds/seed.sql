-- ============================================
-- 1. 拡張機能とヘルパー関数の定義
-- ============================================
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 関数はこちらのコードをお借りした
-- ref: https://github.com/orgs/supabase/discussions/9251#discussioncomment-6199552
-- パスワード付きのユーザーを作成する関数
CREATE OR REPLACE FUNCTION public.create_user_for_test(
    email text,
    password text
) RETURNS uuid AS $$
  declare
  user_id uuid;
  encrypted_pw text;
BEGIN
  user_id := gen_random_uuid();
  encrypted_pw := crypt(password, gen_salt('bf'));
  
  INSERT INTO auth.users
    (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, recovery_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token)
  VALUES
    ('00000000-0000-0000-0000-000000000000', user_id, 'authenticated', 'authenticated', email, encrypted_pw, '2023-05-03 19:41:43.585805+00', '2023-04-22 13:10:03.275387+00', '2023-04-22 13:10:31.458239+00', '{"provider":"email","providers":["email"]}', '{}', '2023-05-03 19:41:43.580424+00', '2023-05-03 19:41:43.585948+00', '', '', '', '');
  
  INSERT INTO auth.identities (id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, provider_id)
  VALUES
    (gen_random_uuid(), user_id, format('{"sub":"%s","email":"%s"}', user_id::text, email)::jsonb, 'email', '2023-05-03 19:41:43.582456+00', '2023-05-03 19:41:43.582497+00', '2023-05-03 19:41:43.582497+00', email);

  RETURN user_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- 3. 開発用データの作成
-- ============================================
-- 開発用のテストユーザーを追加（既存のテストユーザーに加えて）
-- seed.sql内で関数を実行する場合は、doブロックで囲む必要があった
-- ref: https://github.com/supabase/cli/issues/882#issuecomment-1595725535
do $$
begin
    -- ユーザーの作成
    perform public.create_user_for_test('dev1@example.com'::text, 'password123'::text);
    perform public.create_user_for_test('dev2@example.com'::text, 'password123'::text);
end $$;