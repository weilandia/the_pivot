require "rails_helper"

RSpec.feature "UserCreatesAccount", type: :feature do
  scenario "user creates account" do
    category = Category.create(name:"coffee")
    product = category.products.create(name:"Ethiopian", price:1500, description:"Ethiopian coffee is super good", image_url:"http://www.ethiopia-xperience.com/images/Pics_uploaded_by_Jos/EthiopianCoffee2010_586.jpg")

    visit "/products/#{product.id}"
    click_on "Add to cart"

    visit "/"

    click_on "login"
    click_on "signup"

    expect(current_path).to eq("/dashboard")
    fill_in "full name", with: "John Adams"
    fill_in "email", with: "test@test.com"
    fill_in "password", with: "password"

    click_on "signup"

    expect(page).to have_content("Welcome to Little Owl, John.")

    expect(current_path).to eq("/")

    #within whatever
    expect(page).to_not have_link("login")
    expect(page).to have_content("John Adams")
    expect(page).to have_link("logout")
    expect(page).to have_link("order history")
    expect(page).to have_link("settings")

    click_on "cart"
    expect(page).to have_content("Ethiopian")

    click_on "Continue Shopping"

    expect(current_path).to eq("/products")

    click_on "logout"

    expect(page).to have_link("login")
    expect(page).to_not have_link("logout")
    expect(page).to_not have_link("order history")
    expect(page).to_not have_link("settings")
    expect(page).to_not have_content("John Adams")

  end
end
