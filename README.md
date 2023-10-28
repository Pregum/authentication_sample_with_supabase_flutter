# authentication_sample_with_supabase_flutter

This repository is a practice repository to try out the features of "Supabase Authentication".

## How to run

### Setting .env or .env.local

If you use the `--dart-define=ENVIRONMENT=development` option, enter it in the `.env` file.
 If you do not use the `--dart-define=ENVIRONMENT=development` option, enter it in the `.env.local` file.

The contents of `.env` or `.env.local` are as follows.

```shell
SUPABASE_URL=http://localhost:54321 # if use cloud service -> https://xxxxxxxxxxxxxxxxxxxx.supabase.co
SUPABASE_ANONKEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

Enter the URL in `SUPABASE_URL` and anonkey in `SUPABASE_ANONKEY`.

See the following page for information on how to search for anonkey and URL strings.

<https://supabase.com/docs/guides/getting-started/tutorials/with-flutter#get-the-api-keys>

### App

```shell
# run with load '.env'
flutter run --dart-define=ENVIRONMENT=development

# run with load '.env.local'
flutter run 
```

### Local Supabase server

#### Start

```shell
supabase start
```

#### Stop

```shell
supabase stop
```

Please see the page below for details.

<https://supabase.com/docs/guides/cli/local-development>

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
