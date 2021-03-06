require 'rails_helper'

feature 'Create a campaign', :type => :feature do

  let(:email) { Faker::Internet.email }
  let(:user) { User.make! email: email }
  let(:title) { Faker::Lorem.sentence }
  let(:campaign) { Campaign.find_by title: title }
  before do
    @organization = Organization.make!
    @category = Category.make!
  end

  context "when I'm not logged in" do
    scenario 'should redirect me to login page' do
      visit new_campaign_path
      expect(current_path).to be_eql(login_path)
    end
  end

  context "when I'm logged in" do
    before { page.set_rack_session('cas' => {'user' => user.email}) }

    scenario 'should not be enable to select a mobilization' do
      visit new_campaign_path
      expect(page).to_not have_css('select#campaign_hashtag')
    end

    context 'when the campaign is valid' do
      scenario 'should create a campaign with valid data' do
        visit new_campaign_path
        fill_in_campaign_form

        expect(campaign).to_not be_nil
      end

      scenario 'should redirect to the campaign page' do
        visit new_campaign_path
        fill_in_campaign_form

        expect(current_path).to be_eql(campaign_path(campaign))
      end
    end

    context 'when the campaign is invalid' do
      scenario 'should show me error messages', js: true do
        visit new_campaign_path
        fill_in "campaign_new_campaign_spreader_mail", with: ""
        click_button 'campaign-submit-button'

        expect(page).to have_css('input#campaign_title[data-invalid]')
        expect(page).to have_css('textarea#campaign_description[data-invalid]')
        expect(page).to have_css('input#campaign_image[data-invalid]')
        expect(page).to have_css('input#campaign_share_link[data-invalid]')
        expect(page).to have_css('textarea#campaign_tweet[data-invalid]')
        expect(page).to have_css('input#campaign_ends_at[data-invalid]')
        expect(page).to have_css('input#campaign_goal[data-invalid]')
        expect(page).to have_css('textarea#campaign_new_campaign_spreader_mail[data-invalid]')
      end

      scenario 'should render the new campaign page', js: true  do
        visit new_campaign_path
        click_button 'campaign-submit-button'

        expect(current_path).to be_eql(new_campaign_path)
      end
    end
  end

  context "when I'm logged in as admin" do
    let(:user){ User.make! :admin, email: email }
    before { page.set_rack_session('cas' => {'user' => user.email}) }
    before { @mobilization = Mobilization.make! }

    scenario "should be enable to select a mobilization" do
      visit new_campaign_path
      select @mobilization.title, from: 'campaign[hashtag]'
      fill_in_campaign_form

      expect(Campaign.last.mobilization).to be_eql(@mobilization)
    end
  end

  def fill_in_campaign_form
    within('form.new_campaign') do
      fill_in 'campaign[facebook_title]', with: title
      fill_in 'campaign[facebook_message]', with: Faker::Lorem.paragraph
      attach_file 'campaign[facebook_image]', "#{Rails.root}/spec/support/images/whale.jpg"
      fill_in 'campaign[title]', with: title
      select @organization.city, from: 'campaign[organization_id]'
      select @category.name, from: 'campaign[category_id]'
      fill_in 'campaign[short_description]', with: Faker::Lorem.sentence
      fill_in 'campaign[description]', with: Faker::Lorem.paragraph
      attach_file 'campaign[image]', "#{Rails.root}/spec/support/images/whale.jpg"
      fill_in 'campaign[share_link]', with: Faker::Internet.url
      fill_in 'campaign[tweet]', with: Faker::Lorem.sentence
      fill_in 'campaign[ends_at]', with: 1.month.from_now
      fill_in 'campaign[goal]', with: Faker::Number.number(3)
      fill_in 'campaign[new_campaign_spreader_mail]', with: Faker::Lorem.paragraph
      click_button 'campaign-submit-button'
    end
  end
end
