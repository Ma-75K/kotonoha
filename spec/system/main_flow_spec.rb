require "rails_helper"

RSpec.describe "Main Flow", type: :sysytem do
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  it "ログインしてホーム画面に遷移できる" do
    user = create(:user, password: "password", password_confirmation: "password")
    child = create(:child, user: user, name: "さき")

    visit login_path

    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "password"

    click_button "ログイン"

    expect(page).to have_current_path(new_child_recording_path(child))
    expect(page).to have_content("ことばをのこす")
  end

  it "設定画面に移動できる" do
    user = create(:user, password: "password", password_confirmation: "password")
    child = create(:child, user: user)

    visit login_path

    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "password"
    click_button "ログイン"

    visit settings_path

    expect(page).to have_content("お子さま情報設定")
  end

  it "子どもを追加できる" do
    user = create(:user, password: "password", password_confirmation: "password")
    child = create(:child, user: user)

    visit login_path

    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "password"
    click_button "ログイン"

    visit new_from_settings_children_path

    fill_in "名前", with: "みなと"
    fill_in "生年月日", with: "2023-01-01"

    click_button "追加"

    expect(page).to have_current_path(settings_path)
    expect(page).to have_content("みなと")
  end

  it "子どもを編集できる" do
    user = create(:user, password: "password", password_confirmation: "password")
    child = create(:child, user: user)

    visit login_path

    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "password"
    click_button "ログイン"

    visit edit_child_path(child)

    fill_in "名前", with: "さきちゃん"
    click_button "変更"

    expect(page).to have_content("さきちゃん")
  end

  it "主要画面遷移ができる" do
    user = create(:user, password: "password", password_confirmation: "password")
    child = create(:child, user: user)

    visit login_path

    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "password"
    click_button "ログイン"

    visit child_recordings_path(child)
    expect(page).to have_current_path(child_recordings_path(child))

    visit on_this_day_child_recordings_path(child)
    expect(page).to have_current_path(on_this_day_child_recordings_path(child))
  end
end
