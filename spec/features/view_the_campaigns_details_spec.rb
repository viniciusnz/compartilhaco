require 'rails_helper'
include ActionView::Helpers::DateHelper

feature "View the campaign's details", :type => :feature do
  let(:campaign) { Campaign.make! }

  scenario "should see the campaign's title" do
    visit campaign_path(campaign)
    expect(page).to have_css("h2", campaign.title)
  end

  scenario "should see the campaign's image" do
    visit campaign_path(campaign)
    expect(page).to have_css("img", campaign.image.url)
  end

  scenario "should see the campaign's description" do
    visit campaign_path(campaign)
    expect(page).to have_content(campaign.description)
  end

  scenario "should see the campaign's creator" do
    visit campaign_path(campaign)
    expect(page).to have_css(".title", campaign.user.name)
  end

  scenario "should see the campaign's category" do
    visit campaign_path(campaign)
    expect(page).to have_css(".category", campaign.category.name)
  end

  scenario "should see the campaign's end date" do
    visit campaign_path(campaign)
    expect(page).to have_css(".ends_at", distance_of_time_in_words_to_now(campaign.ends_at))
  end
end