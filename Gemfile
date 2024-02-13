source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.0"

gem "rails", "~> 7.0.8"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "bootsnap", require: false
gem "rack-cors"
gem 'devise'
gem 'devise_token_auth'
gem 'devise-i18n'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
  gem "rspec-rails"
  gem "factory_bot_rails"

  # コンソール上でテーブルデータを成型して表示する。
  gem "hirb"
  # hirb日本語補正
  gem "hirb-unicode-steakknife"
  # ダミーデータを生成
  gem "faker"
  gem "gimei"
end
